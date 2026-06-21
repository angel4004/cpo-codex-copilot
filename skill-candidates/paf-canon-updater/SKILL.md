---
name: paf-canon-updater
description: Use when нужно проверить новые источники Product Architecture Framework, PAF, productframework.ru, AI Product Operations, Telegram-канал автора или подготовить proposal-first обновление PAF-канона, practices/paf, methodology memory, source registry, evals или Salamander audit inputs.
---

# Обновление PAF-канона

## Принцип

Обновляй PAF-методологию только через source-grounded proposal. Новая статья,
пост или ссылка сначала становится evidence-кандидатом, затем проходит
классификацию, diff к текущему канону, human review и только потом попадает в
canonical practices или shared memory.

## Быстрый старт

1. Прочитай [source-policy](references/source-policy.md).
2. Проверь [source registry](sources/paf-source-registry.yaml).
3. Выполни local preflight:

```powershell
powershell -NoProfile -File skill-candidates\paf-canon-updater\scripts\check-paf-source-registry.ps1
```

4. Для approved network review собери новые ссылки сайта PAF:

```powershell
powershell -NoProfile -File skill-candidates\paf-canon-updater\scripts\discover-paf-site-links.ps1 -AllowNetwork
```

5. Следуй [update workflow](references/update-workflow.md).
6. Перед готовностью проверь [eval and readiness](references/eval-and-readiness.md).

## Что можно менять

- `sources/paf-source-registry.yaml`: новые источники и статусы freshness.
- `practices/paf/*.md`: только после diff и review.
- `memory/shared/methodology-context.md`: только curated summary, без raw copy.
- `ROUTING.yaml`, `workflow-registry.yaml`, `evals/*`: когда новый слой PAF
  меняет поведение Copilot.

## Что нельзя делать

- Не вставляй raw webpage, raw Telegram transcript или большие цитаты в канон.
- Не делай Telegram, подкаст, Medium или внешний пересказ canonical authority
  без явного human approval.
- Не называй update "PAF-compatible", если не проведен `paf_consistency_review`.
- Не запускай scheduled monitoring, external writes, provider/model API calls,
  push или PR без явного подтверждения Ильи.

## Выходной артефакт

Каждый run должен дать `canonical update proposal`:

- source set и дата проверки;
- новые, измененные, удаленные или спорные источники;
- delta classification: `adopt`, `adapt`, `ignore`, `needs_review`;
- affected claim keys;
- proposed file changes;
- eval/readiness gaps;
- approval checklist.
