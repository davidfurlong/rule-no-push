# Codex Rule: No Git Push Without Approval

This repo contains a Codex rule that forces an approval prompt before the agent can run `git push`.

## What it does

The rule matches the `git push` command prefix and sets the decision to `prompt`, so Codex must ask before publishing commits to a remote.

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
3. Ask Codex to run a `git push` command and confirm that it prompts for approval.

## Optional global setup

If you want the same behavior across all projects, copy the rule contents into a file under:

```text
~/.codex/rules/
```

Then restart Codex.

## Source

OpenAI Codex Rules docs: https://developers.openai.com/codex/rules
