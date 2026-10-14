# Effort on Opus 5.5: the default is `medium`, the stand runs `xhigh`

> Anthropic advises starting Opus 5.5 at `medium`; the profile already says `medium`, but the measured sessions and the stand ran at `xhigh`.

- **Default.** Opus 5.5 defaults to `medium` in the API and in Claude Code; Opus 5 and earlier defaulted to `high`.
- **Advice.** Start at `medium` and test the neighbouring levels; keep `xhigh` and `max` for work with a measured quality gain. Lower the level before adding "think less" instructions.
- **Levels are not comparable across models.** In Anthropic's testing Opus 5.5 at `medium` matches or exceeds Opus 5 at `high` on coding and knowledge work, in fewer steps and with about half the tokens. At a given level Opus 5.5 thinks more per turn than Opus 5, most of all at `xhigh` and `max`.
- **`high` in Claude Code** is described as the level for work where verification matters or edge cases are likely; `medium` — for engineering work with a clear scope.
- **Where a level comes from, first match wins:** `CLAUDE_CODE_EFFORT_LEVEL`, then the `effort` field in the frontmatter of a skill or a subagent, then the session level, then per-model settings, then the model default. Frontmatter overrides the session level but not the environment variable.
- **This machine.** `~/claude/personal/settings.json` has `modelSettings.claude-opus-5-5.effortLevel` = `medium`; the environment variable is not set.
- **The stand** passes `--effort xhigh` in `tests/chain/drive.sh:70`, `judge.sh:102` and `trigger.sh:51`; `series.sh` has no parameter for it. Series `before`, `after` and `en` are all `xhigh` measurements.
- **The skills.** The only mention of effort is `swork/references/slices.md:38`: the executor of a `ready text` slice at `high`. With a session at `medium` that line raises the level instead of lowering it. No `SKILL.md` sets `effort`.
- **Probe 2026-10-13, Claude Code headless.** A skill with `effort` in the frontmatter, started in a session at `--effort high`: the main session and its subagents, nested ones too, write the skill's level. In the next turn (`--resume`) the main session and its new subagents are back at the session level: the pin holds for one turn. Nested subagents work at depth 2.
- **Stand at `medium`, 2026-10-14.** The chain series passes the gate against `en` only after text fixes: 99802 output tokens per run against 396302 at `xhigh` (−75 %), thinking −91 %. Raising the `swork` main session to `high` gave 8 violations instead of 6: the violations were English opening replies and described check output — text, not effort.
- Source: code.claude.com/docs/en/model-config and the bundled `claude-api` skill, section "Migrating to Claude Opus 5.5", read 2026-10-13; the user's words 2026-10-13: "let's put Opus 5.5 on medium, Anthropic advises it, check it"
