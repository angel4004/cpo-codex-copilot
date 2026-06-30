# Создание project passport

## Цель

Создать компактный project passport, в котором видны продуктовый контекст,
предположения и evidence gaps.

## Нужные inputs

- режим product или exploration;
- целевой пользователь/сегмент;
- проблема/job;
- текущая evidence;
- ограничения;
- ожидаемое решение или artifact.

## Шаги

1. Запусти trace через `tools/run-workflow.ps1 -WorkflowId create_project_passport`.
2. Перед новым паспортом для existing product сделай Artifact Inventory Gate:
   проверь доступные local memory, старые паспорта, reports и traces, если они
   разрешены routing. Если найдено несколько паспортов, сначала дай compact
   Passport Registry и различи active, historical и hypothesis passports.
3. Если пользователь дал измеримую цель, но не просил паспорт, не подменяй
   goal-led работу паспортом. Дай `Карта цели` и
   `Следующий артефакт / Следующий проверочный артефакт`, а passport предложи только как downstream
   artifact.
4. Если пользователь запускает новую идею/направление без явного запроса на
   passport, не пиши `Draft Project Passport`, `Compact Project Passport` или
   `[PROJECT PASSPORT]` в первом ответе. Сначала дай literal-блок
   `Первый шаг`, гипотезы/checks и pass/fail критерий. Draft Project Passport
   is forbidden in first new-product response.
5. Если пользователь попросил rough draft или дал минимальный контекст именно
   для паспорта, сразу подготовь компактный черновик в этом же ответе. Не проси
   сначала выбрать `product` или `exploration`, если можно безопасно поставить
   осторожное assumption.
6. Спроси недостающий decision-critical контекст только если без него нельзя
   сделать даже черновик. Вопрос должен быть один и только после частичного
   результата.
7. Подготовь черновик passport, разделив facts, assumptions и gaps.
8. Покажи `Проверка доказательности (PAF)`: уровень доказательств, что
   подтверждено, что является допущением, какие claims заблокированы и что
   проверить следующим.
9. Отметь unsupported PMF/PCF/business-impact claims как forbidden.
10. Закрой trace с artifact refs.

## Выход

Markdown `[PROJECT PASSPORT]` с evidence gaps только когда пользователь явно
просит passport или workflow дошел до downstream passport после первого
validation output.

Минимальный draft должен содержать:

- `Facts`;
- `Assumptions`;
- `Customer / user`;
- `Problem / job`;
- `Value hypothesis`;
- `Current evidence`;
- `Evidence gaps`;
- `Forbidden claims`;
- `Next best action`.

Если trace runner недоступен в текущем runtime, не блокируй пользовательский
draft. Явно отметь `trace_readiness_gap` и всё равно дай полезный
`[PROJECT PASSPORT]`.
