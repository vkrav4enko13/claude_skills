# Pass 1 rules

Translate the Russian skill text into plain, natural English. Translate rule by rule: do not drop, add, soften or strengthen anything. Words such as "never", "only", "always" and "at most" keep their force.

- Keep the shape: the same headings, list items, table rows and code blocks, in the same order.
- Strings listed in `map.tsv` with scope `skills` stay in Russian, exactly in the form the table gives. A mention in another case or letter case is written in the table form.
- Terms follow `glossary.tsv`: one term, one translation.
- Menu labels, report section names, chat forms and placeholders in angle brackets are translated: they are not in the table.
- The front matter fields `description` and `argument-hint` are translated too.
- A Russian sentence that reads two ways: choose the reading closest to the neighbouring rules and add a line to `ambiguous.tsv` in the stand folder with six tab-separated fields: file, line, reading A, reading B, and two empty fields.
- A string the skill writes or reads verbatim that is missing from `map.tsv`: add a row for it first, then keep it in Russian. Name the new row in your reply.
- After translating a file, update the values under its lines in both `phrases.sh` files to the matching text of the translation.
