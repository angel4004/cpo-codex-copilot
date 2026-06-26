# Evidence gap review - проверка gaps

## Цель

Показать, что известно, чего не хватает и какая missing evidence блокирует
рекомендацию.

## Шаги

1. Запусти trace через `tools/run-workflow.ps1 -WorkflowId evidence_gap_review`.
2. Если запрос содержит измеримую цель, начни с `Goal Card`: цель, baseline,
   deadline, definition of success, current evidence sources, biggest unknown и
   next validation artifact.
3. Сделай `Source Routing` перед вопросами к пользователю: какие данные можно
   взять из разрешенных источников, что нужно от пользователя и что недоступно.
4. Извлеки claims и evidence refs.
5. Отметь unsupported PMF, PCF, business-impact и PAF claims.
6. Отдельно выпиши assumptions / допущения, если рекомендация строится на
   слабой или неполной evidence.
7. Назови forbidden claims / unsupported claims, которые нельзя выдавать как
   доказанные.
8. Сгруппируй gaps по влиянию на решение.
9. Покажи `PAF status`: applied/not applied, evidence level, blocked unsupported
   claims, next evidence needed и enforcement caveat.
10. Порекомендуй один следующий evidence-gathering action и decision checkpoint:
    какое решение можно будет принять после этого action.

## Выход

Evidence gap report или goal validation report.
