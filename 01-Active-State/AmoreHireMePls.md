---
project: AmoreHireMePls
repo: /Users/joss/Documents/ChatGPT/AmoreHireMePls
updated: 2026-11-20
---
# AmoreHireMePls state

Map, commands and rules: the repo's `AGENTS.md`. Taken from the handoff of 2026-11-12 (entries to 2026-11-15); nothing here was re-checked against the live system on 2026-11-20. The full handoff: `git show 5e070be:docs/HANDOFF.md` in the repo.

## Now
- NAS stack `amorehiremepls` ran image `lepia/amorehiremepls:1c735bcc39fd` (deployed 2026-11-13), discovery schedule 08:00 and 16:30. Off the home network, deploy with `PORTAINER_URL=http://100.90.96.81:9000`; the script's last LAN health step then fails although the stack is healthy.
- The app has submitted nothing. No employer receipt exists.
- Live and used: profile store, base resume, tracker preview and import (nothing pushed), discovery by URL, deterministic tailoring, review and approval gates, fit check, `candidate/` drop folder, `profile.toml`.
- Fixture tested only: Greenhouse, Lever, Ashby and LinkedIn form filling, the eight-box code field, salary skill, Workday refresh, notifications, human check, site sign-in, account creation, verification mail, stop record across dashboards, application page flow.
- Switches on this stack: site sign-in on, stop record on; account creation and verification mail off until the owner turns them on.
- Never run live: the eight-box email code field (the next live check), a real 1Password read, a real account creation, a mailbox read.
- Profile city and province are still the defaults; `location_fallbacks` is empty.
- Agreed next job source: LinkedIn job alert emails once mail reading works. Searching LinkedIn by script is ruled out.
- Not built: a Sign in now button ahead of an attempt; a count in the side navigation.

## Stopped applications (the owner acts; an agent does not)
- `app_5cf993fc297f4b3e` (LinkedIn): landed on a block page, nothing sent. The owner presses Retry with the app once. Do not sign in again, approve a new package, press I applied on the site, or record a confirmation the site did not show.
- `app_6a78e38192928c99` (job `job_d0f65161045baf54`): reached the email code prompt, not sent. The owner records "It was not sent", presses Retry, and pastes the new code. An agent must not retry it or mark it sent.

## Next
0. Pushed 2026-11-20: `main` at `c81c0dc` (compressed `AGENTS.md`, handoff pointer, `docs/agent-rules.md`, `.cursor/rules/src-conventions.mdc`, `docs/PROGRESS.md` split with older sections in `docs/PROGRESS-archive.md`). Docs and rules only; nothing deployed.
1. The two owner actions above.
2. A higher score resume rebuild through the tailored resume skill. Size M. Needs the owner's go.
3. Save the two later places (`location_fallbacks`) on the Profile page or in `profile.toml`, not in code.
4. After the first confirmed employer receipt: recruiter Connect note drafts, draft only.

## Open questions for the owner
Start date (ASAP or two weeks). Wording for `degree_level`. Internship names: resume or LinkedIn notes. BMO job `job_37efeb56f094fb95`: closed or kept. Copy `profile.toml` to the NAS. Trim the truncated handoff notes file in `candidate/`. Type `pronouns` and `citizenship_status` on forms. Save the later places.

## Decisions
Updates feed comes from stored events, no model call. Captcha solving stays opt in. A typed value on the application beats a profile fact. The watch browser panel and the Network Tab stay off the application page. Grok Bot is out of scope.

## Owner-only steps
Site sign-in and account creation need the Mac dashboard (`http://127.0.0.1:8790`) and the 1Password window. Steps: `.cursor/skills/site-sign-in/SKILL.md` and `.cursor/skills/amore-site-account/SKILL.md` in the repo.
