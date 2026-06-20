# Runtime Contract

## What Codex Executes

Codex reads project instructions, exposes available tools, runs user-approved
local commands and may execute project-local hooks after trust review.
`AGENTS.md` is the bootloader. `CONSTITUTION.md` is semantic authority.

## What Hooks Do

Hooks provide lifecycle observability around prompt, tool and stop events. They
must pass raw input only to `tools/redact-trace-event.ps1` and write redacted
events or safe refs. If hooks are disabled, untrusted or unverified, the system
must report `trace_enforcement_disabled` and lower `trace_enforcement_level`.

## What The Workflow Runner Does

`tools/run-workflow.ps1` starts a workflow state from `workflow-registry.yaml`,
assigns `workflow_id`, `session_id` and `trace_id`, records the selected routing
context, and prepares required artifacts and checks. It is the local entrypoint
for traceable workflows.

## What Local Tools Do

Local tools verify structure, links, memory metadata, memory conflicts, routing,
eval schema, redaction fixtures, trace coverage, migration inventory and commit
readiness. These checks are mechanical gates.

## What Remains Prompt-Level

Product judgement, conversation style, choice of wording and nuanced
interpretation remain prompt-level rules unless a local checker or external
quality gate validates them. Prompt-level rules must not be described as
enforcement.

## Runtime Readiness Levels

- `trusted_hooks`: hooks passed local trust and self-test.
- `runner_only`: runner writes trace state, but hook lifecycle is not proven.
- `disabled_or_untrusted_hooks`: hooks are off or not trusted.
- `unverified_codex_runtime`: current Codex surface cannot prove hook execution.
- `external_protocol_lab`: behavior is checked only by external replay/harness.

Full local trace readiness requires `trusted_hooks` plus passing runner and local
checks.
