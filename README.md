# Codex And Claude Code: No Git Push Without Approval

This repo contains both a Codex rule and a Claude Code policy that force an approval prompt before the agent can publish local commits with either `git push` or GitHub CLI commands that use `--push`.

## What it does

The policy prompts on:

1. `git push`
2. `gh ... --push`, which is the GitHub CLI path that can publish local commits when used with `--push`

For Codex, the extra `gh repo create` rule closes the main GitHub CLI gap without prompting on unrelated `git` commands.

For Claude Code, the checked-in `.claude/settings.json` uses both permission rules and a `PreToolUse` hook. The static `ask` rules catch the common direct commands, and the hook catches compound Bash commands such as `git status && git push` or `gh repo create ... --push`.

## Repository contents

This repository tracks the distributable Codex rule here:

```text
rules/no-git-push-without-approval.rules
```

The live project-local Codex install path is:

```text
.codex/rules/no-git-push-without-approval.rules
```

That local `.codex/` directory is intentionally gitignored so personal Codex config does not get committed.

The Claude Code files tracked in this repository are:

```text
.claude/settings.json
.claude/hooks/require-push-approval.sh
```

## Project setup

To install the Codex rule in a project:

1. Copy `rules/no-git-push-without-approval.rules` into your project's `.codex/rules/` directory.
2. Restart Codex so it reloads rules.
3. Ask Codex to run either `git push` or `gh repo create ... --push` and confirm that it prompts for approval.

## Optional global setup

If you want the same behavior across all projects, copy the rule contents into a file under:

```text
~/.codex/rules/
```

Then restart Codex.

## Claude Code setup

If the target project does not already have Claude Code config:

1. Copy `.claude/settings.json` into the target project's `.claude/` directory.
2. Copy `.claude/hooks/require-push-approval.sh` into the target project's `.claude/hooks/` directory.
3. Make sure `bash` and `python3` are available on the machine running Claude Code.
4. Run `chmod +x .claude/hooks/require-push-approval.sh`.
5. Restart Claude Code so it reloads settings and hooks.
6. Ask Claude Code to run `git push`, `git status && git push`, and `gh repo create ... --push` and confirm that each one prompts for approval.

If the target project already has `.claude/settings.json`, merge in the `permissions` and `hooks` entries instead of overwriting the file. The minimum config to merge is:

```json
{
  "permissions": {
    "ask": [
      "Bash(git push)",
      "Bash(git push *)",
      "Bash(gh * --push)",
      "Bash(gh * --push *)"
    ],
    "disableBypassPermissionsMode": "disable"
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/require-push-approval.sh"
          }
        ]
      }
    ]
  }
}
```

The hook script must also be copied into `.claude/hooks/require-push-approval.sh` and made executable.

## Source

- OpenAI Codex Rules docs: https://developers.openai.com/codex/rules
- Claude Code settings docs: https://code.claude.com/docs/en/settings
- Claude Code permissions docs: https://code.claude.com/docs/en/permissions
- Claude Code hooks docs: https://code.claude.com/docs/en/hooks
