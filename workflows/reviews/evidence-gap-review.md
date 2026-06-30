# Evidence gap review - проверка gaps

## Цель

Показать, что известно, чего не хватает и какая missing evidence блокирует
рекомендацию.

## Шаги

Пользовательские labels для goal-led ответа: `Карта цели`,
`Маршрутизация источников`, `Проверка доказательности (PAF)`,
`Следующий артефакт / Следующий проверочный артефакт`,
`Решение после проверки`. Внутри проверки доказательности добавь строку
`PAF: уровень доказательств ...`.

1. Запусти trace через `tools/run-workflow.ps1 -WorkflowId evidence_gap_review`.
2. Краткость по умолчанию: сначала дай 10-15 строк в чат. Длинный разбор
   выноси в артефакт. В одном сообщении задавай не больше трех вопросов.
3. Если запрос содержит измеримую цель, начни с `Карта цели`: цель, исходная
   точка, срок, критерий успеха, текущие источники доказательств, главный
   неизвестный фактор и ближайший проверочный артефакт.
4. Сделай `Маршрутизация источников` перед вопросами к пользователю: какие
   данные можно взять из разрешенных источников, что нужно от пользователя и
   что недоступно.
5. Если пользователь принес клиентский фидбек, сначала коротко назови сигнал,
   риск для цели и что сделать с этим фидбеком; не начинай с длинного шаблона.
6. Извлеки claims и evidence refs.
7. Отметь unsupported PMF, PCF, business-impact и PAF claims.
   Если пользователь прямо пишет, что нет PMF/PCF/customer-success/business
   evidence, первая строка ответа должна содержать exact anchor:
   `Evidence gap: нет evidence по PMF/PCF/customer success/business impact`.
   Потом дай один next evidence step.
   Если пользователь просит сформулировать forbidden claim без evidence,
   используй fixed refusal template и остановись:
   `Нельзя утверждать: PMF/PCF/бизнес-эффект без evidence refs.`
   `Безопасная формулировка: PMF/PCF/business impact: evidence pending.`
   `Следующий шаг: собрать retention, willingness-to-pay и business-impact evidence.`
   не добавляй optional follow-up, меню вариантов или предложение подготовить
   красивый статус/отчет/сообщение.
8. Отдельно выпиши assumptions / допущения, если рекомендация строится на
   слабой или неполной evidence.
9. Назови forbidden claims / unsupported claims, которые нельзя выдавать как
   доказанные.
10. Сгруппируй gaps по влиянию на решение.
11. Покажи `Проверка доказательности (PAF)`: уровень доказательств, что
   подтверждено, что является допущением, какие claims заблокированы, что
   проверить следующим и есть ли runtime/trace enforcement gap. Добавь
   literal-строку `PAF: уровень доказательств ...`.
12. Если задача про интерфейсный handoff, примени UI-evidence gate: если
   актуальный интерфейс не проверен, не называй handoff готовым.
13. Если задача про сценарии руководителя, проверь полную рамку
   `хорошо / плохо / можно улучшить` до выбора top-5.
14. Если задача разделяет SaleCheckUp Analytics и AI Recovery, держи AI
   Recovery как отдельную гипотезу. Не наследуй доказанность Analytics. Пиши
   exact safe wording: `AI Recovery: гипотеза; доказательства восстановления бронирований пока pending`.
   Не пиши `AI Recovery ... подтвержден...` даже в
   отрицании. Если пользователь прямо просит bridge gates, не задавай вопрос
   первым ответом. Сразу дай exact separation line: `SaleCheckUp Analytics и AI Recovery разделяем: SaleCheckUp Analytics диагностирует звонки; AI Recovery — гипотеза восстановления; между ними нужны bridge gates`.
   Потом дай exact first-response line: `Bridge gates: missed
   call / упущенная возможность; attribution / атрибуция; канал; момент
   реакции; handoff / передача; pilot / baseline metrics`. Не заканчивай
   просьбой подтвердить следующий шаг. До
   revenue/repeat-purchase/success-fee claims явно покажи bridge gates с labels:
   - `Упущенная возможность`: missed opportunity / упущенное бронирование;
   - `Атрибуция`: атрибуция результата связана именно с Recovery-действием;
   - `Канал`: канал, через который идет outreach;
   - `Момент реакции`: момент, когда Recovery должен сработать;
   - `handoff / передача менеджеру`: кому и как передается follow-up;
   - `Пилот / baseline metrics`: baseline, recovery rate, incrementality и
     unit economics.
15. Порекомендуй один следующий evidence-gathering action и decision checkpoint:
    какое решение можно будет принять после этого action.

## Выход

Evidence gap report или goal validation report.
