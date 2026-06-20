# Evidence gap review - проверка gaps

## Цель

Показать, что известно, чего не хватает и какая missing evidence блокирует
рекомендацию.

## Шаги

1. Запусти trace через `tools/run-workflow.ps1 -WorkflowId evidence_gap_review`.
2. Извлеки claims и evidence refs.
3. Отметь unsupported PMF, PCF, business-impact и PAF claims.
4. Сгруппируй gaps по влиянию на решение.
5. Порекомендуй следующий evidence-gathering action.

## Выход

Evidence gap report.
