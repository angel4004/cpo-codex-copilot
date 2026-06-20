# PAF consistency review - проверка

## Цель

Проверить, согласован ли artifact с PAF-линзой, не преувеличивая доказанность.

## Шаги

1. Запусти trace через `tools/run-workflow.ps1 -WorkflowId paf_consistency_review`.
2. Назови PAF layer, который проверяется.
3. Сравни claims с доступной evidence.
4. Отметь missing или distorted methodology elements.
5. Закрой trace с review refs.

## Выход

PAF consistency review с evidence-backed findings.
