# Contributing / Feature Workflow

This project is built feature-by-feature through a GitHub-centric pipeline. Every change starts as an issue and ends as a merged, reviewed PR. This doc defines the loop so both humans and Claude Code follow the same process.

## The loop

1. **Issue** — create a GitHub issue describing the feature/bug/chore. This is the spec.
2. **Plan** — Claude Code enters plan mode, reads the issue, and proposes an implementation approach.
3. **Approve** — a human reviews and approves the plan before any code is written.
4. **Implement** — work happens on a branch created from the issue.
5. **PR** — open a pull request referencing the issue.
6. **CI** — automated checks must pass. (Not wired up yet — see "CI gating" below.)
7. **Merge** — squash-merge into `main` once checks are green. The issue auto-closes and its board card moves to `Done`.

## GitHub Project board

The board (already created on this repo) uses GitHub's default columns:

- **Todo** — issue exists, not started.
- **In Progress** — plan approved and/or implementation underway, including while a PR is open and awaiting CI/merge.
- **Done** — merged, issue closed.

There's no separate "In Review" column — an open PR still counts as "In Progress."

## Issue conventions

- One issue per feature/bug/chore.
- Imperative titles, e.g. "Add Goal model and CRUD views."
- Labels: `type:feature`, `type:bug`, `type:chore`. (`area:*` labels will be introduced once the app's structure exists — that's a decision for the scaffold ticket, not this doc.)
- Issue body is the spec Claude Code plans from. Include:
  - **What** — what should exist after this issue is done.
  - **Why** — the motivation.
  - **Acceptance criteria** — how to tell it's done.

## Branch naming

Use GitHub's "Create a branch" link on the issue itself. It auto-generates `<issue-number>-<slug>` and keeps the issue↔branch link automatic.

## PR conventions

- PR title mirrors the issue title.
- PR description includes `Closes #<issue-number>` so merging auto-closes the issue.
- Target `main`.
- Squash-merge once checks are green.

## CI gating

Not set up yet — there's no application code to test. Once the Django project scaffold exists (its own future issue), a CI workflow will run the test suite on every PR and this section will be updated to describe it.
