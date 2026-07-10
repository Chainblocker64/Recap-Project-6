---
name: implement
description: This skill should be used when the user asks to "implement ticket <number>", "implement the ticket", "start implementing", or when advancing a planned GitHub issue to the implement step of this project's development workflow. Executes work/<number>/plan.md step by step via red-green-refactor - one failing test, one minimal implementation, one commit per acceptance criterion.
---

# Implement

Execute a ticket's plan step by step, each step as its own red-green-refactor TDD cycle ending in its own commit. This is the third step of this project's ticket workflow (see `CONTRIBUTING.md`); it reads the artifact `plan` produced.

## Inputs

Take an issue number as input. If none is given, ask for one rather than guessing.

## Steps

1. Read `work/<number>/plan.md` and `work/<number>/ticket.md`. If `plan.md` doesn't exist, stop and report that this ticket hasn't been planned yet.

2. Confirm the current git branch matches the branch recorded in `ticket.md`. If it doesn't, stop and report this rather than committing to the wrong branch.

3. For each step in `plan.md`, in order:

   a. **Check if already done.** If the test described in this step's "Test (red)" section already exists and passes, skip to the next step rather than redoing it - this makes re-running `implement` after an interruption safe.

   b. **Red.** Write the failing test described in the step's "Test (red)" section. Run the project's test suite and confirm this specific test fails, and fails for the expected reason (not an unrelated error). If it doesn't fail as expected, stop and report rather than proceeding.

   c. **Green.** Make the minimal implementation change described in the step's "Implementation (green)" section - no more than that. Run the full test suite and confirm the new test now passes and nothing else broke. If anything else broke, fix it before proceeding - never move on to the next step with a red suite.

   d. **Refactor.** Look for any obvious cleanup this step's change makes possible (duplication, naming). Apply it only if it doesn't change behavior, and re-run the full suite to confirm still green afterward. Skip this sub-step if there's nothing worth cleaning up - it's not mandatory busywork.

   e. **Commit.** One commit for this step only, message format `Step <n>: <acceptance criterion summary> (#<issue number>)`.

4. Once every step in `plan.md` is done, run `scripts/set-phase.ps1 -Ticket <number> -Phase "implement"` so `work-ticket` can recognize this ticket as being at the implement phase on a future run.

5. Report back which steps were completed and the commits made.
