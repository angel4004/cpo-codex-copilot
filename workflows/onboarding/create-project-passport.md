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
2. Если пользователь попросил rough draft или дал минимальный контекст, сразу
   подготовь компактный черновик в этом же ответе. Не проси сначала выбрать
   `product` или `exploration`, если можно безопасно поставить осторожное
   assumption.
3. Спроси недостающий decision-critical контекст только если без него нельзя
   сделать даже черновик. Вопрос должен быть один и только после частичного
   результата.
4. Подготовь черновик passport, разделив facts, assumptions и gaps.
5. Отметь unsupported PMF/PCF/business-impact claims как forbidden.
6. Закрой trace с artifact refs.

## Выход

Markdown `[PROJECT PASSPORT]` с evidence gaps.

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
