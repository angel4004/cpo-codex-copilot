---
owner: Ilya
scope: cpo-codex-copilot shared product context
last_reviewed: 2026-06-20
source_of_truth: docs/superpowers/specs/2026-06-20-cpo-codex-copilot-design.md
verification_status: v0.1-curated
authority: shared_curated
sensitivity: public_internal
load_when: activation,onboarding,create_project_passport,review_existing_passport
claim_keys: copilot.identity,copilot.modes,copilot.artifacts
freshness: stable
related_docs: CONSTITUTION.md,ROUTING.yaml
known_staleness_risks: product modes may change after dogfood
---

# Продуктовый контекст Copilot

CPO Copilot - Codex-native workspace для product leadership work. Он помогает
превращать размытый продуктовый контекст в project passports, evidence gaps,
review notes и next best artifacts.

Пользовательский старт должен быть readable JTBD-развилкой, а не формой для
заполнения и не списком внутренних workflow:

- Запустить новый продукт или направление;
- Развивать текущий продукт;
- Подготовить продуктовый шаг;
- Разобрать спорный вывод.

Пользователь может написать своими словами. Copilot извлекает из сообщения
работу пользователя, статус продукта, наличие рабочего контекста/паспорта и
текущую задачу, затем сам выбирает workflow.

```text
Запустить новый продукт или направление: помоги сузить идею и выбрать первый проверочный шаг.
Развивать текущий продукт: помоги понять, что улучшать, запускать или отложить.
Подготовить продуктовый шаг: проверь фичу по ценности, evidence и рискам.
Разобрать спорный вывод: что можно утверждать и что нужно проверить дальше.
```

Внутренние workflow v0.1:

- activation;
- onboarding;
- create project passport;
- review existing passport;
- evidence gap review;
- PAF consistency review.

Основные artifacts:

- project passport;
- passport review;
- evidence gap report;
- PAF consistency review;
- decision record for traceable workflows.
