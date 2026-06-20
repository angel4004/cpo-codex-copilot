---
adapter_status: connected
product_specific: false
live_api_status: protocol_live_pass_methodology_infra_blocked
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
- `cpo-protocol-lab` имеет suite `codex-copilot`, который собирает source bundle
  из Codex-native workspace через `AGENTS.md`, а не из legacy GPT Project
  package.
- Root-loop `tools/full-live-codex-copilot-quality.ps1` запускает smoke,
  live protocol artifacts / current-contract replay и methodology audit через
  `Salamander` или фиксирует `infra blocked`, если provider API недоступен.
- `tools/check-live-validation-readiness.ps1` проверяет, что adapter подключен,
  repo остается product-agnostic, а текущий live gap не маскируется под pass.

## Текущий статус

Protocol layer подключен и проверяет новый `cpo-codex-copilot` через
`AGENTS.md`, `CONSTITUTION.md`, `docs/runtime-contract.md`, `ROUTING.yaml`,
`workflow-registry.yaml`, `memory/MANIFEST.yaml`, relevant workflows/practices
и shared memory. Live protocol transcripts по generic русскоязычным scenarios
можно переигрывать через current-contract replay.

Full live readiness пока не равен `pass`: methodology layer подключен к root
оркестратору, но последний live prep может завершиться `infra blocked`, если у
провайдера нет кредитов или подходящего API key.

## Условие full API live validation

Чтобы заявлять full API live validation для этого repo, root-loop должен:

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

Если protocol pass, но methodology API недоступен, итоговый статус должен быть
`infra blocked`, а не `pass`.
