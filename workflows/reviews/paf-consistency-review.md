# PAF consistency review - проверка

## Цель

Проверить, согласован ли artifact с PAF-линзой, не преувеличивая доказанность.

## Шаги

1. Запусти trace через `tools/run-workflow.ps1 -WorkflowId paf_consistency_review`.
2. Назови PAF layer, который проверяется.
3. Если пользователь уже дал claim/context, сразу сделай compact review. Не
   спрашивай, делать ли проверку, если запрос уже просит проверку.
4. Сравни claims с доступной evidence.
5. Отметь missing или distorted methodology elements.
6. Явно перечисли:
   - что можно утверждать;
   - что нельзя утверждать;
   - missing inputs;
   - следующий artifact или проверку.
7. Закрой trace с review refs.

## Выход

PAF consistency review с evidence-backed findings.
