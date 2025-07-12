#Parallel tasks execution

ARGUMENTS: $ARGUMENTS

Step 1: Setup git worktree

Let's firstly setup a few git worktrees in the trees folder depending on the number of parallel agents needed, so we can have different sandbox environments for experimentation.

Run:

git worktree add -b branch-name ./trees/branch-name

Replace branch-name with a good name that reflects the meaning.

After that, for each branch, we should go into the folder (with absolute path) and do:

pnpm install

to set up.

#########################

Step 2: Start Parallel sub agents

We're going to create N new subagents that use the Task tool to execute in each git worktree in parallel.

This enables us to concurrently build the feature in parallel so we can test and validate each subagent's changes in isolation, then pick the best changes.

The first agent will run in trees/<branch-name-1>/
The second agent will run in trees/<branch-name-2>/
...
The last agent will run in trees/<branch-name-n>/

The code in each trees folder will be identical to the code in the current branch. It will be set up and ready for you to build the feature end to end.

Each agent will independently implement the engineering plan based on tasks in their respective workspace.

When the subagent completes its work, have the subagent report their final changes made in a comprehensive RESULTS.md file at the root of their respective workspace.

Make sure agents don't run start.sh or any other script that would start the server or client — focus on the code changes only.