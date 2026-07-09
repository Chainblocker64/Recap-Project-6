---
name: refine
description: This skill should be used when the user asks to "refine ticket <number>", "refine the ticket", "start refining", or when advancing a GitHub issue to the refine step of this project's development workflow. Reads a GitHub issue, rewrites its acceptance criteria so they are verifiable by tests, creates the issue's feature branch, and writes a work/<number>/ticket.md artifact for the next workflow step to read.
---

# Refine

Turn a GitHub issue into a refined, test-verifiable spec, and set up the branch to implement it on. This is the first step of this project's ticket workflow (see `CONTRIBUTING.md`); its output artifact is the starting point for the next workflow step.

## Inputs

Take an issue number as input. If none is given, ask for one rather than guessing - when invoked via `work-ticket`, a number is always supplied.

## Steps

1. Run `scripts/check-prerequisites.ps1`. If it exits with a non-zero code, stop and report exactly what it flagged (e.g. `gh` not installed or not authenticated) instead of proceeding.

2. Fetch the issue with `gh issue view <number> --json number,title,body,url,state`. If `state` is not `OPEN`, stop and report this to the user rather than refining a closed issue.

3. Read the issue body. Per `CONTRIBUTING.md`, it should already contain What / Why / Acceptance criteria sections — treat these as the raw spec.

4. Rewrite the acceptance criteria as a checklist of statements that are concrete and test-verifiable: each one should describe an observable behavior a test could directly assert (e.g. "Creating a Goal with an empty title returns a 400" rather than "Goal creation is validated"). Avoid vague criteria ("works well," "is user-friendly"). If the issue is too thin to derive verifiable criteria from, stop and ask the user to clarify the issue rather than inventing scope.

5. Create and check out the issue's feature branch: `gh issue develop <number> --checkout`. This uses GitHub's linked-branch feature and produces the `<number>-<slug>` branch name convention documented in `CONTRIBUTING.md`.

6. Create the directory `work/<number>/` if it doesn't already exist.

7. Write `work/<number>/ticket.md` with this structure:

   ```markdown
   # Ticket #<number>: <title>

   URL: <issue url>
   Branch: <branch name>

   ## What

   <original "What" from the issue>

   ## Why

   <original "Why" from the issue>

   ## Acceptance criteria (refined, test-verifiable)

   - [ ] <criterion>
   - [ ] <criterion>
   ```

8. Run `scripts/set-phase.ps1 -Ticket <number> -Phase "refine"` so `work-ticket` can recognize this ticket as in progress on a future run.

9. Report back the artifact path and the branch name now checked out.
