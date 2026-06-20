# Review существующего project passport

## Цель

Проверить существующий project passport на gaps, unsupported claims и следующие
hardening steps.

## Шаги

1. Запусти trace через `tools/run-workflow.ps1 -WorkflowId review_existing_passport`.
2. Определи artifact, который проверяется.
3. Раздели strong sections, weak sections и missing evidence.
4. Подготовь приоритизированный hardening list.
5. Закрой trace с review refs.

## Выход

Passport review с severity labels и next actions.
