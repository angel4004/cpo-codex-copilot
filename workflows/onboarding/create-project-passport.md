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
2. Спроси недостающий decision-critical контекст.
3. Подготовь черновик passport, разделив facts, assumptions и gaps.
4. Отметь unsupported PMF/PCF/business-impact claims как forbidden.
5. Закрой trace с artifact refs.

## Выход

Markdown `[PROJECT PASSPORT]` с evidence gaps.
