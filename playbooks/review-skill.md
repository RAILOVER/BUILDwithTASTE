# Playbook: keep this repository honest

**Trigger:** monthly, or after a run of edits.

This is the one review worth asking an agent for, and it is narrow on purpose. You are not here to have opinions about the content. Every rule in these files was paid for with rejected work, and a fresh opinion with no client context would be noise. You are here to find the things that are **provably wrong**.

## Why this is worth doing at all

Everything in this repository was written on one Windows machine, with one Blender build, one set of installed fonts and one set of API credentials. That machine's assumptions are invisible from inside it. A clean Linux machine finds them in minutes.

Two code skeletons in these files contradicted the warnings printed directly above them and stayed wrong for weeks, because nobody ran them. That is the failure mode this playbook exists to catch.

## 1. The reproduction test, which is the most valuable part

Take the repository on a clean machine and try to follow it literally, as a competent stranger would.

- Run `bash pipeline/setup.sh` and record every step that needed something the instructions did not mention.
- Run each code block in `taste-frontend/references/blender-pipeline.md`, `interactivity.md`, `cinematic-scroll.md` and `asset-generation.md`.
- For each: does it run, does it do what the text says, are the numbers still true?

Report per block: ran clean, ran with a change (show the change), or did not run (show the error). **Do not correct prose you have not executed.**

Known hazards worth checking first, because they are machine specific:

- Blender version enums. The files pin to one series. Print the valid values on this machine and compare.
- Blender render engine. The files assume EEVEE. A headless machine may only have Cycles.
- Fonts. The files name faces that may be installed on the author's machine and nowhere else.
- Windows paths and junctions. Anything using them needs a stated Linux equivalent.
- API routes. Endpoints move and free tiers close. Check each documented route still answers, and report the status code rather than editing the file from memory.

## 2. The mechanical checks

```
node check.js
```

Must print PASS. If it does not, fix what it names.

## 3. Contradictions between files

The files cross reference heavily and drift apart. Look for a rule stated one way in one file and another way elsewhere: a number that differs, a format recommended in one place and banned in another, a phase order that does not match between the pipeline and its own checklist.

Report them as pairs with line references. **Do not pick a winner.** Which one is right is a decision for the person.

## 4. Dead ends

- A skill named as a delegation target that is not installed. It fails silently.
- A cross reference to a file that no longer exists, which `check.js` catches.
- A documented route or tool that no longer works.

## What not to touch

- Anything in `taste-frontend/references/PREFERENCES.md` Part 1. Those are refusals from a client, quoted. They are not style choices to revisit.
- The phase order in `taste-rebrand/SKILL.md`. The brand folder is built before the site on purpose.
- The review gate. It is a hard stop.
- Any suggestion that starts with "consider adding". If it is not provably wrong, it is not in scope.

## Output

One pull request, plus a report with four sections: reproduction results per code block, `check.js` output, contradictions as pairs, dead ends. Fix only what is mechanically wrong and prove it with a run. Everything else is a list for the person to decide on.

## Definition of done

Every code block in the repository has been executed on a clean machine and labelled, and no claim in the report is unverified.
