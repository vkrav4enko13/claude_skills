# S3. Skills check without a model

> One script tells, without a model run, whether the skills still link, cite and contain what the stand needs.

- **Status:** done
- **Covers:** R21, R3, R5
- **Depends on:** S1
- **Files:**
  - create: `tests/skills-check.sh`
  - change: `tests/chain/rules.md`, `tests/chain/rules-survey.md` (the stale citations)
- **Interfaces:**
  - gives: `bash tests/skills-check.sh [--root <dir>]` → `skills ok` exit 0, or one line per fault and exit 1: `link: <file>: <target>`, `heading: <file>: <heading>`, `citation: <rule id>: <file>:<line>`, `literal: <string>`
- **Reuse:** the link pattern of `sbrain/scripts/check.sh`; the literal list of `plan.md` "Shared constraints"
- **What to do:**
  - Links: every relative `](…)` in `sbrain/ splan/ swork/ saway/` resolves from its file.
  - Headings, three citation forms, paths from the skill root (`references/x.md`) or the file's folder: `"<Heading>" of \`<path>\``, `` `<path>` `## <Heading>` ``, `section "<Heading>"` naming a file in the same sentence; the heading must exist in that file.
  - Citations: for every `— <skill>/<file>:<line>` of the two rule lists, the cited line or one line around it shares at least two content words with the rule. The script prints the stale ones; fix each by moving the number, never the rule text.
  - Literals: the strings of `plan.md` "Shared constraints", each found in the skills.
- **Checks:** lines 7, 8, 9
