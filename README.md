# Codex Rule: No Git Push Without Approval

This repo contains a Codex rule that forces an approval prompt before the agent can publish local commits with either `git push` or `gh repo create ... --push`.

## What it does

The rule prompts on:

1. `git push`
2. `gh repo create`, which is the GitHub CLI path that can publish local commits when used with `--push`

Codex rules match command prefixes, so the extra `gh repo create` rule closes the GitHub CLI gap without prompting on unrelated `git` commands.

## Repository contents

This repository tracks the distributable rule here:

```text
rules/no-git-push-without-approval.rules
```

The live project-local install path is:

```text
.codex/rules/no-git-push-without-approval.rules
```

That local `.codex/` directory is intentionally gitignored so personal Codex config does not get committed.

## Project setup

To install it in a project:

1. Copy `rules/no-git-push-without-approval.rules` into your project's `.codex/rules/` directory.
2. Restart Codex so it reloads rules.
3. Ask Codex to run either `git push` or `gh repo create ... --push` and confirm that it prompts for approval.

## Optional global setup

If you want the same behavior across all projects, copy the rule contents into a file under:

```text
~/.codex/rules/
```

Then restart Codex.

## Source

OpenAI Codex Rules docs: https://developers.openai.com/codex/rules
