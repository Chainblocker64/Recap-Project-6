---
name: plan
description: This skill should be used when the user asks to "plan ticket <number>", "plan the ticket", "start planning", or when advancing a refined GitHub issue to the plan step of this project's development workflow. Reads a ticket's refined spec, explores the codebase for relevant context, and writes a work/<number>/plan.md artifact structured as one TDD cycle per acceptance criterion, for the next workflow step to implement from.
---

# Plan

Turn a refined ticket into an implementation plan structured as test-driven-development cycles, one per acceptance criterion. This is the second step of this project's ticket workflow (see `CONTRIBUTING.md`); it reads the artifact `refine` produced and writes the artifact the next step will implement from.

## Inputs

Take an issue number as input. If none is given, ask for one rather than guessing.

## Steps

1. Read `work/<number>/ticket.md`. If it doesn't exist, stop and report that this ticket hasn't been refined yet instead of guessing at its spec.

2. Launch three sub-agents (Agent tool, `subagent_type: "Explore"`) in parallel - a single message with three tool calls, not sequential - each covering one concern, all given the ticket's What/Why/Acceptance criteria as background:
   - **Existing patterns**: how similar features are structured in this codebase (file/module layout, naming conventions, how comparable functionality is organized).
   - **Test setup**: existing test conventions, fixtures, and pytest-django configuration relevant to testing this ticket's acceptance criteria.
   - **Data layer**: existing models, migrations, and database schema relevant to this ticket.

   For the earliest tickets, before any application code exists, expect these to often report back "nothing exists yet" - that's a valid finding, not a failure, and just means the plan will be establishing the pattern rather than following one.

3. Write all three sub-agents' findings to `work/<number>/exploration.md`, one section per concern (Existing patterns / Test setup / Data layer), verbatim or lightly cleaned up - this is a record of what informed the plan, not something to re-synthesize further.

4. Using `ticket.md` and `exploration.md`, write `work/<number>/plan.md` with one step per acceptance criterion, each describing a single red-green TDD cycle:

   ```markdown
   # Plan for Ticket #<number>: <title>

   Branch: <branch name>

   ## Step 1: <acceptance criterion, verbatim from ticket.md>

   **Test (red):** <the specific test to write, and why it should currently fail>

   **Implementation (green):** <the minimal implementation change to make that test pass>

   ## Step 2: <next acceptance criterion>

   ...
   ```

   Steps must be ordered so each one is independently implementable given only the previous steps being done - don't produce steps with hidden forward dependencies.

5. Run `scripts/set-phase.ps1 -Ticket <number> -Phase "plan"` so `work-ticket` can recognize this ticket as being at the plan phase on a future run.

6. Report back both artifact paths.
