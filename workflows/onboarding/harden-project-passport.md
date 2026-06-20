# Hardening project passport - усиление

## Цель

Превратить слабый passport в более decision-ready artifact без выдумывания
данных.

## Шаги

1. Запусти trace через `tools/run-workflow.ps1 -WorkflowId harden_project_passport`.
2. Примени passport review.
3. Сохрани known facts.
4. Преобразуй unsupported claims в assumptions или evidence gaps.
5. Закрой trace с ref на hardened artifact.
