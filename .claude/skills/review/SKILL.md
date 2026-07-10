---
name: review
description: This skill should be used when the user asks to "review ticket <number>", "review the ticket", "start review", or when advancing an implemented GitHub issue to the review step of this project's development workflow. Has independent sub-agents review the diff for general and security issues and confirm the acceptance criteria are met, writing a work/<number>/review.md verdict. FAIL extends the plan with fix steps and rewinds the ticket's phase so a future implement run picks them up, then stops for the user to confirm before continuing; PASS pushes the branch and opens the pull request.
---

# Review

Independently review a ticket's implementation before it ships. This is the fourth and final step of this project's ticket workflow (see `CONTRIBUTING.md`).

## Inputs

Take an issue number as input. If none is given, ask for one rather than guessing.

## Steps

1. Read `work/<number>/ticket.md` (for the acceptance criteria and branch name) and confirm the current git branch matches it. If it doesn't, stop and report rather than reviewing the wrong branch.

2. Get the full diff for this ticket - `git diff main...HEAD` (every commit made on this branch, not just the latest).

3. Launch two independent sub-agents in parallel (Agent tool, single message with two tool calls). Give both only the diff and the acceptance criteria from `ticket.md` - not `implement`'s reasoning or `plan.md` - so they assess the result fresh rather than inheriting its assumptions:
   - **General reviewer** (`subagent_type: "general-purpose"`): review the diff for correctness bugs and quality issues, and explicitly confirm or refute each acceptance criterion against the actual diff/tests - don't take it on faith that implementation satisfied them.
   - **Security reviewer** (`subagent_type: "security-reviewer"`): review the diff for security issues.

4. Write `work/<number>/review.md`:

   ```markdown
   # Review for Ticket #<number>

   Verdict: PASS | FAIL

   ## Acceptance criteria
   - [x] <criterion>: confirmed by <evidence>
   - [ ] <criterion>: not met - <reason>

   ## General findings

   <findings, or "None">

   ## Security findings

   <findings, or "None">
   ```

   Verdict is PASS only if every acceptance criterion is confirmed met and neither sub-agent raised an unresolved finding. Otherwise it's FAIL.

5. Increment a `reviewAttempts` counter in `work/<number>/state.json` each time this skill runs. If this is the 4th attempt or beyond for this ticket, stop and report the situation to the user instead of looping again - don't retry indefinitely on your own.

6. **If FAIL:** append new steps to `work/<number>/plan.md` addressing every unmet criterion and finding, in the same `Step N` / Test (red) / Implementation (green) format as the existing steps. Run `scripts/set-phase.ps1 -Ticket <number> -Phase "plan"` (rewinding so the next dispatch resolves to `implement`). Report the verdict and the newly added plan steps back to the user, then **stop** - don't invoke `implement` automatically. The user reviews the added steps and explicitly starts the next phase themselves.

7. **If PASS:** push the branch (`git push -u origin <branch>`), then open the PR with `gh pr create` - title mirroring the issue title, body containing `Closes #<number>` per `CONTRIBUTING.md`. Run `scripts/set-phase.ps1 -Ticket <number> -Phase "review"`. Report the PR URL back to the user - this is the human checkpoint in this workflow.
