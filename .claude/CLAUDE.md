## Cross-Platform System Preferences

Font, terminal color-scheme, and general desktop-setup preferences (portable across
Linux/Windows/macOS) live in `PREFERENCES.md` — split out since it's about machine setup,
not coding standards, and grows independently:

@PREFERENCES.md

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
- Small, atomic commits explaining why, not just what.
- Never commit secrets — use gitignored `.env` + a committed `.env.example` (keys, no values).
- Once a project has real users/releases: maintain CHANGELOG.md and semver (MAJOR.MINOR.PATCH) tags.

## 5. Security & Configuration
- No hardcoded credentials/keys/tokens; env-specific values (URLs, ports, etc.) come from config/env vars.
- Validate and sanitize input at system boundaries; avoid OWASP-class mistakes (injection, XSS, insecure deserialization).

## 6. Dependencies
Prefer well-maintained, minimal dependencies over reinventing basics or pulling in heavy libraries for small needs. Commit lockfiles for reproducible builds.

## 7. Error Handling & Logging
Fail loudly on real errors — don't swallow exceptions. Use leveled logging, not stray print/console statements left in place.

## 8. Licensing
Every project gets a LICENSE file, chosen per its intended use (open-source, private, internal tooling).
