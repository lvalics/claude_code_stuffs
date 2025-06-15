# Session Management Guide

## Overview

The session management system helps prevent conversation length limits and ensures smooth handovers between Claude sessions. It integrates with the existing Claude Code framework to provide continuous workflow support.

## Key Components

### 1. Session State File
Location: `.claude/session/current-session.yaml`

This file tracks:
- Session health and message count
- Current mode and scope
- Active task information
- Working context (files, branches, etc.)
- Todo list status

### 2. Health Check System

#### Automatic Health Checks
- **On Start**: Always performed when conversation begins
- **Every 10 Messages**: Background check with warnings
- **On Demand**: User can trigger with `<Health-Check>`

#### Health Indicators
- 🟢 **Healthy (0-30)**: Normal operation
- 🟡 **Approaching (31-45)**: Plan for handover
- 🔴 **Handover Now (46+)**: Immediate action needed

### 3. Operating Modes

Modes control Claude's response style:
- **DEBUG**: Detailed error analysis and troubleshooting
- **BUILD**: Implementation and feature development
- **REVIEW**: Code review and optimization
- **LEARN**: Educational explanations
- **RAPID**: Quick, concise responses

Switch modes with: `MODE: [mode_name]`

### 4. Scope Classification

Defines work complexity:
- **MICRO**: 1-5 lines of code
- **SMALL**: 5-20 lines
- **MEDIUM**: 20-50 lines
- **LARGE**: 50+ lines
- **EPIC**: Multi-file changes

Set scope with: `SCOPE: [scope_level]`

## Commands Reference

### Primary Commands
- `<Health-Check>` - Check session health
- `<Handover01>` - Generate handover document
- `<Session-Metrics>` - Detailed statistics

### Mode Commands
- `MODE: DEBUG` - Switch to debug mode
- `MODE: BUILD` - Switch to build mode
- `MODE: REVIEW` - Switch to review mode
- `MODE: LEARN` - Switch to learn mode
- `MODE: RAPID` - Switch to rapid mode

### Scope Commands
- `SCOPE: MICRO` - Set micro scope
- `SCOPE: SMALL` - Set small scope
- `SCOPE: MEDIUM` - Set medium scope
- `SCOPE: LARGE` - Set large scope
- `SCOPE: EPIC` - Set epic scope

### Action Keywords
- **SWITCHING TO** - Change context/task
- **PARKING** - Save current work
- **RESUMING** - Continue previous work
- **BLOCKING** - Mark as blocked
- **ESCALATING** - Escalate issue

## Workflow Examples

### Starting a New Task
```
User: Implement user authentication for VCS-234
Claude: <Health-Check>
        Setting MODE: BUILD, SCOPE: LARGE
        Loading security best practices...
        Creating implementation plan with handover points...
```

### Mid-Session Health Warning
```
Claude: ⚠️ Session Health: 🟡 Approaching (35 messages)
        Recommendation: Complete current authentication module, then handover.
        Use <Handover01> when ready.
```

### Generating Handover
```
User: <Handover01>
Claude: Generating handover document...
        ✓ Session state saved
        ✓ Todo list updated
        ✓ Handover document created
        Ready for new session. Load handover-2025-01-15.md to continue.
```

### Resuming Work
```
User: Continue from previous session
Claude: Loading session state...
        Resuming VCS-234 - authentication (60% complete)
        MODE: BUILD, SCOPE: LARGE
        Next: Implement JWT token validation
```

## Best Practices

### 1. Proactive Health Management
- Monitor health indicators
- Plan handovers at natural breakpoints
- Don't wait until 🔴 status

### 2. Mode Selection
- Use appropriate mode for task type
- Switch modes as work evolves
- DEBUG for troubleshooting, BUILD for implementation

### 3. Scope Planning
- Set realistic scope for session length
- Break EPIC tasks into session-sized chunks
- Plan handover points in implementation

### 4. Handover Quality
- Complete logical units before handover
- Update todo lists accurately
- Include all relevant context

## Integration with Existing Workflow

### With JIRA Tasks
- Session tracks JIRA ID automatically
- Handover includes task progress
- Implementation plans include session breakpoints

### With Git Workflow
- Session tracks current branch
- Handover includes uncommitted changes
- Resume instructions include git status

### With Todo System
- Todo status included in session state
- Completed items tracked per session
- Handover shows pending work

## Troubleshooting

### Session State Not Loading
1. Check `.claude/session/current-session.yaml` exists
2. Verify YAML syntax is valid
3. Manually run `<Health-Check>` to reinitialize

### Health Check Not Running
1. Ensure CLAUDE.md includes session management section
2. Trigger manually with `<Health-Check>`
3. Check for mode/scope commands

### Handover Missing Information
1. Update session state before handover
2. Ensure todos are current
3. Include manual notes if needed

## Advanced Usage

### Custom Session Tracking
Add custom fields to session state:
```yaml
custom:
  api_endpoints_completed: 5
  test_coverage: 85%
  performance_baseline: "recorded"
```

### Multi-Session Planning
For EPIC scope work:
1. Plan session breakpoints upfront
2. Create session-specific goals
3. Track progress across sessions

### Team Handovers
When handing over to team members:
1. Include extra context in notes
2. Document decision rationale
3. List any blockers or questions