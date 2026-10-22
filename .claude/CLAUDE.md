## Cross-Platform System Preferences

Font, terminal color-scheme, and general desktop-setup preferences (portable across
Linux/Windows/macOS) live in `PREFERENCES.md` — split out since it's about machine setup,
not coding standards, and grows independently:

@PREFERENCES.md

## Private notes (synced via Nextcloud, not dotfiles)

`TODO.md` and `NETWORK.md` below are symlinks into `~/Nextcloud/claude/`, so they sync to
every device with the Nextcloud client but never reach the public dotfiles repo (they hold
home-network details and open security to-dos). Edit them in place; never add them back
to dotfiles. On a new machine: `ln -s ~/Nextcloud/claude/{TODO,NETWORK}.md ~/.claude/`.

## Global To-Dos

Cross-project/machine-setup items left over from a session — not tied to any one repo —
live in `TODO.md`, checked and updated as they're picked up or completed:

@TODO.md

## Home Network Knowledge Base

Running history/reference for this machine's and other local network devices' setup
(DNS, DHCP, router, Pi-hole, etc.) and changes made to them — kept as an append-only log
so troubleshooting knowledge accumulates across sessions instead of being rediscovered:

@NETWORK.md

## Where Claude sessions start

Start sessions in `~/dev/projects/` or any folder below it (e.g. a repo such as
`~/dev/projects/ATLAS`). Never start one in the `~/dev` root itself or in
`~/dev/releases/` — those hold no work of their own, and sessions there leave sandbox
leftovers (`~/dev/.claude/`, `~/dev/.mcp.json`) and a catch-all project memory. A `claude`
function in `~/.bashrc` enforces this. Long-running programs run from
`~/dev/releases/<repo>/<program>/current/` (deployed with `deploy-release <repo> <program>`; `deploy-release --pending <repo>` lists what is behind), never
from a working checkout.

# Engineering Standards for New Projects

Goal: any project should be in a state where another engineer can step in and work on it without a guided tour.

## 1. Code Maintainability & Style
- DRY — don't duplicate logic across files. Single responsibility per file/class; split rather than accumulate unrelated concerns. Applies to styling too — reuse shared design tokens/utility classes instead of re-declaring near-identical CSS per component. Before writing a new helper function, constant, or style block, check whether an equivalent already exists elsewhere in the codebase and reuse or extract it rather than writing a parallel copy.
- Favor clear naming over comments; comment only non-obvious "why" (constraints, workarounds, invariants).
- Enforce style with the ecosystem's standard linter/formatter, not convention alone.

## 2. Documentation (README.md)
Keep current: what the project does, setup from a clean machine, how to run it and its tests, required env vars/config, key architecture decisions. Update the README in the same change that alters documented behavior, not as a follow-up.

## 3. Testing
Test core logic and bug fixes where practical (no hard coverage target). A change isn't done until its tests pass. Bug fixes ship with a regression test.

## 4. Git & Versioning
- **No Claude attribution anywhere in git/GitHub.** Commit messages get no
  `Co-Authored-By: Claude …` trailer, and PR titles/descriptions/comments get no
  "Generated with Claude Code" line or any other mention of Claude. This overrides the
  harness's default attribution reminder.
- Small, atomic commits explaining why, not just what.
- Never commit secrets — use gitignored `.env` + a committed `.env.example` (keys, no values).
- Once a project has real users/releases: maintain CHANGELOG.md and semver (MAJOR.MINOR.PATCH) tags.
- **Work in a dedicated git worktree, never directly on `main`/`master`.** This comes from
  a real incident (ATLAS repo, 2026-09-23): two agent sessions worked on `main`
  simultaneously with no worktrees, and reconciling their changes at commit time turned
  into painstaking file-by-file untangling. At the start of a session — or as soon as any
  code change is about to happen — create a new worktree/branch and do all work there;
  stay in that one worktree for the rest of the session rather than hopping between
  worktrees/branches (that's previously left this machine's checkouts in a tangled state
  — stray checked-out branches, confusion about which worktree has which change). Once the
  work is complete (committed, merged/PR'd if that's the plan), suggest the worktree be
  removed (`git worktree remove <path>`) rather than removing it unilaterally. `main` stays
  reserved for the user's own manual work.

## 5. Security & Configuration
- No hardcoded credentials/keys/tokens; env-specific values (URLs, ports, etc.) come from config/env vars.
- Validate and sanitize input at system boundaries; avoid OWASP-class mistakes (injection, XSS, insecure deserialization).

## 6. Dependencies
Prefer well-maintained, minimal dependencies over reinventing basics or pulling in heavy libraries for small needs. Commit lockfiles for reproducible builds.

## 7. Error Handling & Logging
Fail loudly on real errors — don't swallow exceptions. Use leveled logging, not stray print/console statements left in place.

## 8. Licensing
Every project gets a LICENSE file, chosen per its intended use (open-source, private, internal tooling).
