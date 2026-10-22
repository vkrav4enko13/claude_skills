# S7. Hooks of the chain

> The chain's key rules reach every Claude Code session at start, resume, clear and compaction and every subagent at its start, a language line comes with every user prompt, and a broken hook never stops the session.

- **Status:** done
- **Covers:** R38, R39, R40, R41
- **Depends on:** S2
- **Files:**
  - create: `hooks/chain-rules.md`, `hooks/inject.sh`, `hooks/lang.sh`
  - create: `tests/hooks-test.sh`, `tests/hooks-live.sh`
  - change: `install.sh` (header comment; a list of the two Claude Code profiles; install and `--uninstall` of the hooks on the Mac only)
- **Interfaces:**
  - takes: executor rule numbers 4, 8, 11–16 (S2)
  - gives: the folder `hooks/` — S9 copies it into stand boxes; the first line of `chain-rules.md` is `# Chain rules`; the settings entries below; the marker is the path part `/chain-hooks/` of a hook command
- **Reuse:** `jq` (`/opt/homebrew/bin/jq`, already used by `tests/chain/trigger.sh:29`); the profile loop and `--uninstall` branch of `install.sh`; the case-line style of `tests/agents-test.sh`
- **What to do:**
  1. `hooks/chain-rules.md`, verbatim:
     ```
     # Chain rules

     These apply while a chain skill — sbrain, splan, swork or saway — is in use.

     - The chain is sbrain → splan → swork; saway works for a user who is away. A skill does not move to the next stage by itself: the user chooses.
     - No product code in sbrain or splan; swork writes it by an approved plan or a small clear task.
     - Reply to the user in the language of their own words; files, cards and subagent tasks are in English.
     - Subagents of the chain run at effort medium.
     - Any code you write follows rules 4, 8 and 11–16 of the executor task in {{SKILLS}}/swork/references/executor.md: the reach of the change first, the cheapest rung that works, the never-cut list above it.
     - A detailed explanation the user asks for is given in full.
     - The last message of a chain skill has, before its menu or its fixed last line, one or two lines: what was not done, what was not verified, any risk.
     ```
  2. `hooks/inject.sh`: read stdin; take `.hook_event_name` with `jq`; `SessionStart` → print `chain-rules.md` (next to the script) with `{{SKILLS}}` replaced by the absolute path of `$(dirname "$0")/../skills` (the text is printed even when that folder is missing); `SubagentStart` → print `{"hookSpecificOutput":{"hookEventName":"SubagentStart","additionalContext":<the same text>}}`; anything else, unreadable input, no `jq` or no rules file → print nothing. Always exit 0; no `set -e`.
  3. `hooks/lang.sh`: print `Reply to the user in the language of their own words.` and exit 0.
  4. `install.sh`, Mac only, for `$HOME/claude/personal` and `$HOME/claude/work` (not `~/.codex`, not the PC): copy `hooks/` to `<profile>/chain-hooks/` (replace the folder); in `<profile>/settings.json` (missing → `{}`) remove every hook whose command contains `/chain-hooks/` and every event list left empty, then add — each with `"type":"command"`, `"timeout": 5`:
     - `SessionStart`, `"matcher": "startup|resume|clear|compact"`, command `bash "<profile>/chain-hooks/inject.sh"`;
     - `SubagentStart`, no matcher, the same command;
     - `UserPromptSubmit`, no matcher, command `bash "<profile>/chain-hooks/lang.sh"`.
     Write through a temp file and `mv`; all other keys and hooks stay. `--uninstall` removes our entries and `<profile>/chain-hooks/`.
  5. `tests/hooks-test.sh`: a stand-in home `mktemp -d "${CHAIN_BASE:-$HOME/Documents/my/chain-stand}/hooks.XXXXXX"`; `claude/personal/settings.json` = `{"model":"x","hooks":{"Stop":[{"hooks":[{"type":"command","command":"claude-notify"}]}]}}`; `claude/work/` without `settings.json`; `.codex/config.toml` with one line. Run `HOME=<it> bash install.sh --mac` twice, then `--uninstall --mac`. Cases, one line each `<case>: ok|FAIL`: `install` (3 of ours in each profile after the first run), `rerun` (still 3), `kept` (`model` and the `Stop` hook kept), `missing` (the work profile file created with 3), `codex` (`config.toml` unchanged, no `chain-hooks` under `.codex`), `uninstall` (0 of ours, `Stop` kept, no `chain-hooks` folders); last `hooks: all ok` or exit 1.
  6. `tests/hooks-live.sh`: a temp project under `CB` whose `.claude/settings.json` holds the same three entries pointing at this repo's `hooks/`; two `claude -p` calls like `tests/chain/drive.sh:107-115` at `--effort medium`: (a) `Is there a block titled "Chain rules" in your context? Answer only yes or no.`; (b) `Start one subagent with the Agent tool and ask it: is there a block titled "Chain rules" in your context, yes or no? Reply only with its answer.` Print `session: <answer>` and `subagent: <answer>`, lower case, punctuation removed.
- **Checks:** lines 28–34
