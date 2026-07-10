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

2. Launch one sub-agent (Agent tool, `subagent_type: "Explore"`) to investigate the codebase for context relevant to this ticket's acceptance criteria - existing patterns, relevant files/modules, and conventions to follow when implementing them. Give it the ticket's What/Why/Acceptance criteria as background. (This is currently a single agent covering the whole ticket; a future revision may fan this out into multiple concern-specific explore agents run in parallel - don't build that now, just leave this step easy to extend.)

3. Write the sub-agent's findings to `work/<number>/exploration.md`, verbatim or lightly cleaned up - this is a record of what informed the plan, not something to re-synthesize further.

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
