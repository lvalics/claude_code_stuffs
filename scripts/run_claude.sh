#!/bin/bash

# Claude JIRA Task Automation
# Processes JIRA tasks from /tasks/ directory structure
# Creates implementation plans before coding
# Uses todo lists for complex tasks
# Logs each task separately
# Tracks completion with flag files
# Shows colored status summary
# Progress Tracking: Tracks attempts per task and detects loops
# Handover Documents: Creates detailed handover files in .claude/session/ when stopping
# Reformulation Prompts: Different approaches for 2nd and 3rd attempts
# Health Check Integration: Uses <Health-Check> command to monitor session state
# Better Logging: Separate logs per task attempt with clear status indicators

# Configuration
MAX_ITERATIONS=20  # Reduced to avoid hitting limits
MAX_RETRIES_PER_TASK=3  # Max attempts before reformulating
DELAY_BETWEEN_RUNS=5
DELAY_AFTER_STUCK=30  # Longer delay when stuck
TASKS_DIR="tasks"
LOGS_DIR="logs"
CHANGES_DIR="claude_code_changes"
SESSION_DIR=".claude/session"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Create necessary directories
mkdir -p "$LOGS_DIR" "$CHANGES_DIR" "$SESSION_DIR"

echo -e "${GREEN}=== Claude JIRA Task Automation ===${NC}"
echo "Starting at $(date)"

# Track task attempts and progress
declare -A task_attempts
declare -A task_progress_hash

# Function to detect model limits
check_for_limits() {
    local output="$1"
    if echo "$output" | grep -qi "limit reached\|rate limit\|too many requests\|cannot continue"; then
        echo -e "${RED}⚠️  Model limit reached. Creating handover document...${NC}"
        return 0
    fi
    return 1
}

# Function to detect if Claude is stuck
is_stuck() {
    local task_id="$1"
    local current_output="$2"
    
    # Create a hash of the current output to detect loops
    local current_hash=$(echo "$current_output" | md5sum | cut -d' ' -f1)
    
    # Check if we've seen similar output before
    if [ "${task_progress_hash[$task_id]}" == "$current_hash" ]; then
        return 0  # Stuck - same output as before
    fi
    
    # Update the hash
    task_progress_hash[$task_id]="$current_hash"
    
    # Check for common stuck patterns
    if echo "$current_output" | grep -qi "I'll wait\|let me try again\|I'll continue\|I need to\|retrying" > /dev/null 2>&1; then
        # Check if no actual progress was made (no file edits, no tests run)
        if ! echo "$current_output" | grep -qi "updated\|created\|modified\|passed\|failed\|error" > /dev/null 2>&1; then
            return 0  # Stuck - lots of planning, no action
        fi
    fi
    
    return 1  # Not stuck
}

# Function to create handover document
create_handover() {
    local task_id="$1"
    local iteration="$2"
    local reason="$3"
    
    handover_file="$SESSION_DIR/handover_${task_id}_$(date +%Y%m%d_%H%M%S).md"
    
    cat > "$handover_file" << EOF
# Handover Document for Task $task_id

## Session Summary
- **Date**: $(date)
- **Iterations**: $iteration
- **Reason**: $reason
- **Task Directory**: $TASKS_DIR/$task_id/

## Current Status
EOF
    
    # Add task status
    if [ -f "$TASKS_DIR/$task_id/.progress" ]; then
        echo "### Progress" >> "$handover_file"
        cat "$TASKS_DIR/$task_id/.progress" >> "$handover_file"
    fi
    
    # Add recent attempts
    echo -e "\n### Recent Attempts" >> "$handover_file"
    echo "Attempts made: ${task_attempts[$task_id]:-0}" >> "$handover_file"
    
    # Add recommendations
    echo -e "\n## Recommendations for Next Session" >> "$handover_file"
    if [ "$reason" == "stuck" ]; then
        echo "- Task appears stuck. Consider breaking it down further or trying a different approach." >> "$handover_file"
        echo "- Review the implementation plan and identify specific blockers." >> "$handover_file"
    elif [ "$reason" == "limit" ]; then
        echo "- Model limit reached. Continue from where this session left off." >> "$handover_file"
        echo "- Check completed todos and continue with pending items." >> "$handover_file"
    fi
    
    echo -e "\n## Next Steps" >> "$handover_file"
    echo "1. Run: \`claude 'Continue task $task_id from handover document @$handover_file'\`" >> "$handover_file"
    echo "2. Review the task progress and any blockers" >> "$handover_file"
    echo "3. Continue implementation following the existing plan" >> "$handover_file"
    
    echo -e "${BLUE}📋 Handover document created: $handover_file${NC}"
}

# Function to get next task from tasks directory
get_next_task() {
    # Find task directories with -specs.md files
    for task_dir in "$TASKS_DIR"/*; do
        if [ -d "$task_dir" ]; then
            task_id=$(basename "$task_dir")
            specs_file="$task_dir/${task_id}-specs.md"
            
            # Check if specs exist and task is not completed
            if [ -f "$specs_file" ] && [ ! -f "$task_dir/.completed" ]; then
                # Check if we haven't exceeded retry limit
                if [ "${task_attempts[$task_id]:-0}" -lt "$MAX_RETRIES_PER_TASK" ]; then
                    echo "$task_id"
                    return 0
                fi
            fi
        fi
    done
    return 1
}

# Function to check if task is completed
is_task_completed() {
    local task_id="$1"
    local task_dir="$TASKS_DIR/$task_id"
    
    # Task is completed if .completed flag exists
    [ -f "$task_dir/.completed" ]
}

# Function to get reformulation prompt
get_reformulation_prompt() {
    local task_id="$1"
    local attempt="$2"
    
    if [ "$attempt" -eq 2 ]; then
        echo "Task $task_id seems stuck. Let's try a different approach:
1. First run '<Health-Check>' to check session state
2. Review @/tasks/$task_id/${task_id}-specs.md
3. Identify what's blocking progress
4. Break down the problem into smaller steps
5. Focus on completing just ONE small part
6. Document any blockers in .blocked file"
    else
        echo "Task $task_id still not progressing. Final attempt:
1. Create a minimal implementation that addresses the core requirement
2. Document any issues preventing full implementation
3. If truly blocked, create .blocked file with:
   - What was attempted
   - Specific error or issue
   - What's needed to unblock
4. Mark task as blocked and move to next"
    fi
}

# Main execution
iteration=0
total_limit_hits=0

# Check if any tasks exist
if [ ! -d "$TASKS_DIR" ] || [ -z "$(ls -A "$TASKS_DIR" 2>/dev/null)" ]; then
    echo -e "${RED}No tasks found in $TASKS_DIR directory. Exiting.${NC}"
    exit 0
fi

# Main loop
while [ $iteration -lt $MAX_ITERATIONS ]; do
    iteration=$((iteration + 1))
    
    # Get next task
    if ! task_id=$(get_next_task); then
        echo -e "${GREEN}✅ All tasks completed or max retries reached!${NC}"
        break
    fi
    
    # Initialize or increment task attempts
    task_attempts[$task_id]=$((${task_attempts[$task_id]:-0} + 1))
    attempt=${task_attempts[$task_id]}
    
    # Create task-specific log file
    task_log="$LOGS_DIR/${task_id}_attempt${attempt}_$(date +%Y%m%d_%H%M%S).log"
    
    echo "" | tee -a "$task_log"
    echo -e "${YELLOW}=== Iteration $iteration | Task: $task_id | Attempt: $attempt/$MAX_RETRIES_PER_TASK ===${NC}" | tee -a "$task_log"
    
    # Choose prompt based on attempt number
    if [ "$attempt" -eq 1 ]; then
        # First attempt - normal prompt
        PROMPT="Process JIRA task $task_id following this workflow:

1. Run '<Health-Check>' to establish session state
2. Read the task specifications from @/tasks/$task_id/${task_id}-specs.md
3. Create an implementation plan in @/tasks/$task_id/${task_id}-IMPLEMENTATION.md
4. Break down the task into a todo list using TodoWrite tool
5. Implement the solution step by step, updating todos as you progress
6. Run tests and validate the implementation
7. Document all changes in @$CHANGES_DIR/claude_changes_$(date +%Y-%m-%d_%H-%M).txt
8. When complete, create a .completed flag file in the task directory
9. If blocked, create a .blocked file with specific details
10. Update .progress file with current status

Focus on making concrete progress. If stuck, identify the specific blocker."
    else
        # Retry attempt - use reformulation
        PROMPT=$(get_reformulation_prompt "$task_id" "$attempt")
    fi
    
    # Run Claude
    echo "Running Claude for task $task_id (attempt $attempt)..." | tee -a "$task_log"
    output=$(claude --continue --permission-mode bypassPermissions -p "$PROMPT" 2>&1)
    echo "$output" | tee -a "$task_log"
    
    # Check for model limits
    if check_for_limits "$output"; then
        ((total_limit_hits++))
        create_handover "$task_id" "$iteration" "limit"
        echo -e "${RED}Stopping due to model limits. Total limit hits: $total_limit_hits${NC}"
        break
    fi
    
    # Check if task was completed
    if is_task_completed "$task_id"; then
        echo -e "${GREEN}✓ Task $task_id completed${NC}" | tee -a "$task_log"
        unset task_attempts[$task_id]
        unset task_progress_hash[$task_id]
    else
        # Check if stuck
        if is_stuck "$task_id" "$output"; then
            echo -e "${MAGENTA}⚠️  Task $task_id appears stuck (attempt $attempt)${NC}" | tee -a "$task_log"
            
            if [ "$attempt" -ge "$MAX_RETRIES_PER_TASK" ]; then
                echo -e "${RED}Max retries reached for $task_id. Creating handover...${NC}"
                create_handover "$task_id" "$iteration" "stuck"
                # Create blocked file
                echo "Task stuck after $MAX_RETRIES_PER_TASK attempts. Manual intervention required." > "$TASKS_DIR/$task_id/.blocked"
            else
                echo "Waiting $DELAY_AFTER_STUCK seconds before retry..." | tee -a "$task_log"
                sleep $DELAY_AFTER_STUCK
                continue
            fi
        else
            echo -e "${YELLOW}Task $task_id still in progress${NC}" | tee -a "$task_log"
        fi
    fi
    
    # Wait before next iteration
    if [ $iteration -lt $MAX_ITERATIONS ]; then
        echo "Waiting $DELAY_BETWEEN_RUNS seconds..." | tee -a "$task_log"
        sleep $DELAY_BETWEEN_RUNS
    fi
done

# Final summary
echo ""
echo -e "${GREEN}=== Summary ===${NC}"
echo "Total iterations: $iteration"
echo "Model limit hits: $total_limit_hits"

# Count completed tasks
completed_count=0
pending_count=0
blocked_count=0

for task_dir in "$TASKS_DIR"/*; do
    if [ -d "$task_dir" ]; then
        task_id=$(basename "$task_dir")
        if [ -f "$task_dir/.completed" ]; then
            ((completed_count++))
            echo -e "${GREEN}✓ $task_id - Completed${NC}"
        elif [ -f "$task_dir/.blocked" ]; then
            ((blocked_count++))
            echo -e "${RED}⚠️  $task_id - Blocked (attempts: ${task_attempts[$task_id]:-0})${NC}"
            [ -f "$task_dir/.blocked" ] && cat "$task_dir/.blocked"
        elif [ -f "$task_dir/${task_id}-specs.md" ]; then
            ((pending_count++))
            attempts="${task_attempts[$task_id]:-0}"
            echo -e "${YELLOW}○ $task_id - Pending (attempts: $attempts)${NC}"
        fi
    fi
done

echo ""
echo "Tasks completed: $completed_count"
echo "Tasks pending: $pending_count"
echo "Tasks blocked: $blocked_count"

# Create session summary
if [ "$total_limit_hits" -gt 0 ] || [ "$blocked_count" -gt 0 ]; then
    echo -e "\n${BLUE}💡 Recommendations:${NC}"
    
    if [ "$total_limit_hits" -gt 0 ]; then
        echo "- Model limits reached. Review handover documents in $SESSION_DIR/"
        echo "- Consider running tasks in smaller batches"
    fi
    
    if [ "$blocked_count" -gt 0 ]; then
        echo "- Some tasks are blocked. Review .blocked files for details"
        echo "- Consider breaking down complex tasks into smaller subtasks"
    fi
fi

echo -e "\nCompleted at $(date)"