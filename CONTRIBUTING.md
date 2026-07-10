# Contributing / Feature Workflow

This project is built feature-by-feature through a GitHub-centric pipeline. Every change starts as an issue and ends as a merged, reviewed PR. This doc defines the loop so both humans and Claude Code follow the same process.

## The loop

Implementation is autonomous end-to-end - there's no plan-approval checkpoint before code gets written. The human checkpoint is the pull request.

1. **Issue** — create a GitHub issue describing the feature/bug/chore, added to the board in `Todo`. This is the spec.
2. **`work-ticket`** — the pipeline's entry point (a Claude Code skill). Picks up this issue, or resumes one already in progress, and dispatches through the phases below.
3. **`refine`** — rewrites the issue's acceptance criteria so they're test-verifiable, and creates the issue's branch.
4. **`plan`** — explores the codebase and writes an implementation plan structured as one TDD cycle (red/green) per acceptance criterion.
5. **`implement`** — works through the plan step by step: one failing test, one minimal implementation, one commit, per step.
6. **`review`** — independent sub-agents check the diff for general and security issues and confirm every acceptance criterion is actually met.
   - **FAIL** — new plan steps addressing the findings are added, and the ticket loops back through `implement` automatically.
   - **PASS** — the branch is pushed and a PR is opened. This is where you come in - there's no earlier approval gate.
7. **Your review** — you review the actual code in the PR.
8. **CI** — automated checks must pass. (Not wired up yet — see "CI gating" below.)
9. **Merge** — squash-merge into `main` once your review and checks are green. The issue auto-closes and its board card moves to `Done`.

## GitHub Project board

The board (already created on this repo) uses GitHub's default columns:

- **Todo** — issue exists, not started.
- **In Progress** — the pipeline (`refine` through `review`) is running, including while a PR is open and awaiting your review/CI/merge.
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
