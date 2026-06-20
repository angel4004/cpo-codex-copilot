---
adapter_status: not_connected
product_specific: false
live_api_status: not_run
validated_target: cpo-codex-copilot
---

# Live validation - статус

Этот repo не настроен под конкретный продукт. Generic behavior evals должны
проверять CPO Copilot как универсальный инструмент для продуктового лидера:
activation, onboarding, project passport, evidence gap review и PAF consistency
review.

## Что уже есть

- `evals/behavior/*.yaml` содержат продукт-агностичные русские prompts и
  expected behavior.
- `evals/protocol/protocol-lab-adapter-smoke.case.yaml` фиксирует generic
  adapter smoke case.
- `tools/check-live-validation-readiness.ps1` проверяет, что live-validation gap
  явно описан и не маскируется под pass.

## Что не доказано

Existing `cpo-protocol-lab` читает legacy source bundle из `../cpo`:
`runtime/core/*.md`, `runtime/project_setup/*.md` и launch prompt. Existing
`Salamander` также ожидает CPO working package / source snapshot старого типа.

Новый `cpo-codex-copilot` запускается через `AGENTS.md`, `CONSTITUTION.md`,
`docs/runtime-contract.md`, `ROUTING.yaml`, workflows, practices и memory
manifest. Поэтому старый full-live loop нельзя считать проверкой нового
Codex-native Copilot.

## Условие full API live validation

Чтобы заявлять full API live validation для этого repo, нужен adapter, который:

1. собирает source bundle из `AGENTS.md`, `CONSTITUTION.md`,
   `docs/runtime-contract.md`, `ROUTING.yaml`, `workflow-registry.yaml`,
   `memory/MANIFEST.yaml`, relevant workflows/practices и shared memory;
2. запускает generic русскоязычные behavior scenarios без product-specific
   context;
3. прогоняет observable dialogue через `cpo-protocol-lab`;
4. прогоняет methodology mapping через `Salamander` или эквивалентный PAF audit;
5. сохраняет reports с refs на exact commit, bundle hash, scenario ids и
   forbidden claims;
6. не пишет raw private context, raw prompts, raw tool args или raw tool output.

До появления такого adapter статус остается `adapter_status: not_connected` и
`live_api_status: not_run`.
