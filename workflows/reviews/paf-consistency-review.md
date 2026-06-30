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
6. Явно перечисли one-line-per-heading shape, без bullet-list:
   - `Доказательства`: какие данные уже есть;
   - `Не хватает`: missing inputs / gaps;
   - `Допущения`: assumptions, если evidence неполная;
   - `Нельзя утверждать`: forbidden claims / unsupported claims;
   - `Можно утверждать`: осторожные evidence-backed claims;
   - `Проверка доказательности (PAF)`: `PAF: уровень доказательств ...`;
   - `Следующий артефакт`: один next artifact или одну проверку;
   - `Следующий шаг`: один next artifact или одну проверку, которая закрывает
     главный evidence gap.
7. Это compact answer, не отчет: всего 6-8 строк, без detailed checklist и без
   вопроса в финальной строке. Если нужны thresholds, выбери conservative
   defaults и пометь их как допущение.
8. Закрой trace с review refs.

## Выход

PAF consistency review с evidence-backed findings. В финальном ответе используй
явные заголовки `Доказательства`, `Не хватает`, `Нельзя утверждать` и
`Следующий шаг`, чтобы evidence, gaps, forbidden claims и next action были
проверяемыми в protocol/eval artifacts. Заверши ровно одним default action.
