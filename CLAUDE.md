# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Recap Project 6 is a full-stack Django "learning companion" app (learning goals, session tracking, AI-generated summaries/suggestions via OpenAI). The project has not been scaffolded yet — no Django code exists at this point, only the feature development workflow.

See `CONTRIBUTING.md` for the feature development workflow: every feature starts as a GitHub issue (the spec), then flows autonomously through the `work-ticket` → `refine` → `plan` → `implement` → `review` skills - each phase stops for you to confirm its artifact before the next one begins - and out through a PR back to `main`. Follow this loop for every feature, including the initial project scaffold.

## Repo layout

The `scripts/` directory referenced by the workflow skills (e.g. `scripts/check-prerequisites.ps1`, `scripts/set-phase.ps1`) lives at the project root, not under `.claude/`. It's shared across `work-ticket`, `refine`, `plan`, `implement`, and `review` - run these paths relative to the repo root.

## Secrets

Never read the contents of `.env` (or any `.env.*` file) and never print, quote, or otherwise output its contents. If you need to know whether a variable is set, check for its key by name (e.g. `grep -o '^KEY_NAME' .env`) without echoing values.
