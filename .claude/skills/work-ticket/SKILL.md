---
name: work-ticket
description: This skill should be used when the user asks to "work ticket <number>", "work on ticket <number>", "start the workflow", or otherwise wants to begin or resume this project's ticket pipeline. Entry point for the pipeline (see CONTRIBUTING.md) - checks the machine has the required tools, resumes a ticket already in progress if one exists, otherwise selects the oldest open Todo ticket from the GitHub Project board, then dispatches into the first workflow-step skill (refine). Holds no phase-specific workflow logic itself.
---

# Work Ticket

Entry point for this project's ticket workflow. Its job is only to make sure the machine is ready and figure out *which* ticket to work on - each workflow phase is its own dedicated skill that owns its own logic and artifacts under `work/<number>/`.

## Inputs

Take an issue number as input, if given - this overrides ticket selection below.

## Steps

1. Run `scripts/check-prerequisites.ps1`. If it exits with a non-zero code, stop and report exactly what it flagged instead of proceeding.

2. Determine which ticket to work on:
   - If an issue number was given as input, use it directly.
   - Else, look for a ticket already in progress: check for any `work/<number>/state.json` (list subdirectories of `work/` and test each for a `state.json`). If one exists, resume with that ticket's number. (Only one ticket is expected to be in progress at a time under this solo-dev workflow - if more than one is found, stop and ask the user which to resume rather than guessing.)
   - Else, run `scripts/select-next-ticket.ps1` to get the oldest open ticket in the board's Todo column. If it exits non-zero (no tickets available), stop and report this instead of proceeding.

3. Invoke the `refine` skill, passing the resolved ticket number. (This is currently the only workflow-step skill; as more are added, this step will need to dispatch to whichever skill matches the ticket's current phase instead of always `refine`.)
