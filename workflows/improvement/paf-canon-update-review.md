# Обновление PAF-канона - review

## Цель

Проверить новые PAF-источники и подготовить `canonical_update_proposal`, не
изменяя методологический канон автоматически.

## Входы

- source URL, seed URL или запрос "проверь новые PAF-источники";
- `skill-candidates/paf-canon-updater/SKILL.md`;
- `skill-candidates/paf-canon-updater/sources/paf-source-registry.yaml`;
- текущие `practices/paf` и `memory/shared/methodology-context.md`.

## Шаги

1. Запусти trace через `tools/run-workflow.ps1 -WorkflowId paf_canon_update_review`.
2. Прочитай source policy и registry skill-кандидата.
3. Запусти local preflight `check-paf-source-registry.ps1`.
4. Для разрешенного network review запусти `discover-paf-site-links.ps1 -AllowNetwork`.
5. Сравни найденные источники с текущим PAF canon.
6. Классифицируй delta как `adopt`, `adapt`, `ignore` или `needs_review`.
7. Подготовь proposal с affected claim keys, target files, risks и required evals.
8. Остановись до изменения canonical files, если human approval не было дано.

## Запрещено

- Делать Telegram, подкаст или внешний пересказ каноном без review.
- Переносить raw webpage или raw Telegram transcript в tracked docs.
- Утверждать PAF consistency без `paf_consistency_review`.

## Выход

`canonical_update_proposal` с source set, delta classification, proposed diff
plan, eval impact и approval checklist.
