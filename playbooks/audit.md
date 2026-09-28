# Playbook: audit a prospect's repository

**Trigger:** a repository URL arrives, usually from a prospect who wants to know what is wrong with their site.

This is the studio's lead generator. It turns a cold conversation into a deliverable. The output is not a critique, it is a diagnosis that names files.

## What you produce

Two documents, both in `taste/` in a working branch.

**`AUDIT.md`**, a table, one row per finding:

| Pattern | Location | Severity | Fix direction |
|---|---|---|---|

The detection list is `taste-rebrand/references/audit-patterns.md`. Walk it in full: copy and content, structure and product, motion, brand.

**Every finding cites a file and a component.** "Generic hero" is not a finding. "Hero in `components/Hero.tsx` uses a 135deg purple to blue gradient with a floating laptop mockup and no real product screenshot" is a finding. The difference is what makes a prospect believe you looked.

**`CONTRACT.md`**, the backend contract, extracted per `taste-rebrand/references/contract-extraction.md`: API routes with real request and response shapes read from the handler bodies, the auth flow step by step, data models from the schema, third party integrations, and env var **names only, never values**.

Do not read a real `.env`. The example or template file only.

## Also measure

- Baseline JavaScript bundle size, so the rebuild has a number to stay within.
- Core Web Vitals on a throttled mobile profile.
- The asset count. The floor is eight distinct real assets on a brand page, and a generic site is usually far under it. This single number is often the most persuasive line in the whole audit.

## Tone of the findings

Plain and specific. No mockery: the prospect built this and may be in the room when it is read. State what is there, why it reads as generic, and what it costs them. The reference corpus in `taste-frontend/references/reference-corpus.md` is the standard to compare against, so cite it rather than asserting taste.

## What you must not do

Do not propose a visual direction, a palette, a typeface or a name. That is the paid work, and giving it away in the audit both devalues it and produces generic output, which is what this studio sells against. The audit ends at diagnosis.

## Definition of done

Every pattern in the detection list has been checked and either cited with a location or explicitly marked absent. The contract is complete enough that a rebuild would not break anything in it. Both documents read as if a person spent a day in the repository.
