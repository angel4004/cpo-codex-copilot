---
owner: Ilya
scope: cpo-codex-copilot operating principles
last_reviewed: 2026-06-20
source_of_truth: AGENTS.md and CONSTITUTION.md
verification_status: v0.1-curated
authority: shared_curated
sensitivity: public_internal
load_when: all
claim_keys: copilot.operating_rules,privacy.boundary,approval.boundary
freshness: stable
related_docs: AGENTS.md,CONSTITUTION.md,docs/runtime-contract.md
known_staleness_risks: Codex hook behavior may change
---

# Рабочие принципы

- Спрашивай недостающий контекст, если иначе сильный продуктовый вывод будет
  unsupported.
- Не считай private local memory shared truth.
- Не печатай secrets, `.env` values, raw private transcripts или raw provider
  payloads.
- Для traceable workflows используй workflow runner или явно фиксируй readiness
  gap.
- External writes и provider calls вне Codex runtime требуют явного approval.
