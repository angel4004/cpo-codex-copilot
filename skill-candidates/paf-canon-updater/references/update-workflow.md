# Update workflow - обновление канона

## 1. Source freshness

Проверь registry и собери новые ссылки. Для local-only проверки запусти
`check-paf-source-registry.ps1`; для approved network review запусти
`discover-paf-site-links.ps1 -AllowNetwork`.

Фиксируй дату проверки, seed URLs, недоступные страницы, redirects и ссылки,
которых нет в registry.

## 2. Delta classification

Каждый источник классифицируй:

- `adopt`: официальный PAF-источник добавляет или уточняет правило.
- `adapt`: полезно для Copilot, но требует упаковки как prompt/workflow/eval.
- `ignore`: не относится к PAF-канону или дублирует существующее.
- `needs_review`: есть риск трактовки, непубличность, конфликт или слабая связь
  с PAF.

## 3. Canonical update proposal

До изменения canonical files подготовь proposal:

- source set;
- affected claim keys;
- direct statements with safe excerpts;
- inferred interpretation отдельно от direct;
- target files;
- forbidden claims;
- eval/readiness impact;
- human approval checklist.

## 4. Применение после review

После human approval обновляй только минимальные файлы:

- `practices/paf/paf-knowledge-layer.md` для методологического слоя;
- `practices/paf/answer-modes.md` или `evidence-and-uncertainty.md`, если
  изменилось поведение ответа;
- `memory/shared/methodology-context.md` для curated shared memory;
- `ROUTING.yaml` и `workflow-registry.yaml`, если появился новый task type;
- `evals/behavior` или `evals/structural`, если нужен новый gate.

## 5. Trace и проверки

Для methodology-affecting change используй traceable workflow
`paf_consistency_review` или явно отметь, почему runner недоступен. Проверки:

```powershell
powershell -NoProfile -File tools\run-smoke.ps1
```

Если менялся PAF runtime behavior, нужен внешний methodology/protocol audit в
`cpo-quality-ecosystem` до утверждения production-ready.
