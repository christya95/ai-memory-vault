---
project: AmoreHireMePls
repo: /Users/joss/Documents/ChatGPT/AmoreHireMePls
updated: 2026-11-20
---
# AmoreHireMePls

Local job-search assistant for one candidate. Python with `uv`, LangChain, LangGraph, Jinja pages, Docker Compose, MongoDB on the NAS. Code root `src/amorehiremepls/`.

## Read order
1. This note.
2. `docs/HANDOFF.md` (about 4k tokens): state and queue. The repo's `AGENTS.md` requires it at session start.
3. Only the files the map names.

Do not read whole: `docs/PROGRESS.md` (about 35k tokens, search it), `CURSOR_PROMPT.md` (about 6k), `runtime/`, logs, stop records.

## Map (under `src/amorehiremepls/` unless prefixed)
- Browser plans, code boxes: `apply/browser.py`
- Form rules: `apply/applications.py`, `apply/ats/rules.py`; site adapters in `apply/ats/`
- Application page: `web/app_flow.py`, `web/templates/application.html`, `web/templates/_macros.html`, `tests/test_app_flow.py`, `docs/ui-copy.md`
- Sign-in: `apply/signin.py`, `core/site_signin.py`, `core/credentials.py`, `core/sealed.py`
- Account creation, verification mail: `apply/signup.py`, `core/account_items.py`, `core/mail_access.py`, `core/mail_codes.py`
- Stop record: `apply/stop_record.py`, `web/stop_view.py`
- Jobs page, schedule: `web/jobs_paste.py`, `web/jobs_refresh.py`, `core/schedule.py`, `core/worker.py`
- Profile: `candidate/candidate_profile.py`
- Model steps: `core/skills.py`; external actions: `core/actions.py`, `core/authorization.py`
- Deploy: `scripts/deploy_nas.sh`, `deploy/nas/compose.yaml`, `docs/nas-deployment.md`

## Commands
- Test: `env -u PLAYWRIGHT_BROWSERS_PATH -u UV_CACHE_DIR -u TMPDIR -u __CURSOR_SANDBOX_ENV_RESTORE uv run pytest -q -p no:cacheprovider` (outside the sandbox)
- Lint: `uv run ruff check src tests && uv run ruff format --check src tests`
- Deploy: Operating rules in `docs/HANDOFF.md`

## Rules that are easy to break
- An agent never retries a live application, sends a message, or grants an approval.
- Never print secrets or profile values. Never commit `candidate/` private files, `runtime/`, `.env`, `.env.references`.
- No profession, city, employer, or person's name as a literal under `src/`.
- A changed prompt or skill input needs a version bump in `core/skills.py`.

## Now
From `docs/HANDOFF.md`, read 2026-11-20 (file dated 2026-11-12, entries to 2026-11-15). Not checked against the live system.
- The app has submitted nothing. No employer receipt exists.

## Next
The queue in `docs/HANDOFF.md`. Its top items are owner actions on two stopped applications; agents must not perform them.
