# Working on these files

Written for an autonomous agent as much as for a person. Devin, Claude Code and anyone else editing this repository follow the same rules.

## What this repository is

Instructions, not an application. There is nothing to build, no test suite, no server. A change is correct when the instructions are accurate, internally consistent and executable, and wrong when they describe something that has not been run.

## Before opening a pull request

Run `node check.js`. It is the whole CI, and it is dependency free so it runs in any checkout. It covers the first three checks below; the fourth is on you.

**1. No em dashes or en dashes.**

```
grep -rnP "[\x{2014}\x{2013}]" --include=*.md .
```

Must return nothing. The underlying ruleset bans them as a generated-text tell and shipped files have failed this before.

**2. Every cross-reference resolves.** The files refer to each other by bare filename. Every markdown filename that appears in the text must either exist in this repository or be a document the pipeline creates at run time (`BRAND.md`, `INTAKE.md`, `AUDIT.md`, `CONTRACT.md`, `REVIEW_SUMMARY.md`, `HANDOFF.md`, `CHECKLIST.md`, `site-plan.md`, `prompts.md`, `MOTION.md`).

**3. No skill name that is not installed.** Delegating to a skill that does not exist in the environment is a silent failure. This happened once: the strategy phase delegated to an image-generation skill whose tool was absent, so the phase quietly produced nothing.

**4. Code blocks have been executed.** If a change adds or edits a code skeleton, run it first and paste real output or real numbers. Two skeletons in this repository contradicted the traps written directly above them, because nobody ran them.

## Rules about the rules

- **State the failure.** Every rule exists because something was shipped and rejected. Write what was shipped, what happened, and the quote if there is one. A rule with no evidence is a preference.
- **Preferences belong in `PREFERENCES.md`,** with the client's own words. That file outranks every other default, so it is the one place where "because they said so" is a sufficient reason.
- **Do not add a second route to the same result.** Several routes were tried and documented as refused. Adding a new one reopens a settled question.
- **Measurements, not adjectives.** "Lighter" is not a finding. "576KB as WebP against 6.3MB as PNG, on 36 frames at 720px" is.

## What not to change without being asked

- Anything in `PREFERENCES.md` Part 1. Those are refusals from the client, not opinions to revisit.
- The phase order in `taste-rebrand/SKILL.md`. The `brand/` folder is built before the site on purpose.
- The review gate. It is a hard stop, not a formality.

## Scope of an agent task

Good tasks here are narrow and checkable: fix a broken cross-reference, verify a code skeleton runs and correct it, add a documented failure to the relevant file, check the dash rule across the repository, reconcile two files that now contradict each other.

Bad tasks are ones that require taste: choosing a visual direction, writing brand strategy, deciding what a client's site should feel like. Those decisions belong to the person, and the whole point of this repository is that they were made with evidence rather than generated.
