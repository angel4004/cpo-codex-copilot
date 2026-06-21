# Runtime-контракт

## Что исполняет Codex

Codex читает проектные инструкции, показывает доступные tools, запускает
одобренные пользователем локальные команды и может исполнять project-local hooks
после trust review. `AGENTS.md` - bootloader. `CONSTITUTION.md` - semantic
authority.

## Что делают hooks

Hooks дают lifecycle observability вокруг prompt, tool и stop events. Они должны
передавать raw input только в `tools/redact-trace-event.ps1` и писать redacted
events или safe refs. Если hooks отключены, untrusted или unverified, система
обязана зафиксировать `trace_enforcement_disabled` и понизить
`trace_enforcement_level`.

## Что делает workflow runner

`tools/run-workflow.ps1` стартует workflow state из `workflow-registry.yaml`,
назначает `workflow_id`, `session_id` и `trace_id`, записывает выбранный routing
context и подготавливает required artifacts/checks. Это локальный entrypoint для
traceable workflows.

## Что делают local tools

Local tools проверяют structure, links, memory metadata, memory conflicts,
routing, eval schema, PAF canon updater readiness, redaction fixtures, trace
coverage, migration inventory, language readiness и commit readiness. Эти
checks являются mechanical gates.

## Что остается prompt-level

Product judgement, стиль диалога, выбор формулировок и nuanced interpretation
остаются prompt-level rules, пока локальный checker или внешний quality gate не
валидирует их. Prompt-level rules нельзя описывать как enforcement.

## Уровни runtime readiness

- `trusted_hooks`: hooks прошли local trust и self-test.
- `runner_only`: runner пишет trace state, но hook lifecycle не доказан.
- `disabled_or_untrusted_hooks`: hooks выключены или не trusted.
- `unverified_codex_runtime`: текущая Codex surface не может доказать hook
  execution.
- `external_protocol_lab`: behavior проверяется только внешним replay/harness.

Полная local trace readiness требует `trusted_hooks`, passing runner и local
checks.
