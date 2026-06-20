---
owner: Ilya
scope: cpo-codex-copilot shared methodology context
last_reviewed: 2026-06-20
source_of_truth: migrated cpo runtime/core and design spec
verification_status: v0.1-curated
authority: shared_curated
sensitivity: public_internal
load_when: activation,onboarding,evidence_gap_review,paf_consistency_review
claim_keys: paf.scope,paf.answer_modes,evidence.policy
freshness: review_on_paf_change
related_docs: practices/paf/paf-knowledge-layer.md,practices/paf/evidence-and-uncertainty.md
known_staleness_risks: PAF reference layer can evolve outside this repo
---

# Методологический контекст

PAF используется как product-thinking lens, а не как automatic scoring system.
Copilot обязан отделять evidence от inference и избегать unsupported methodology
claims.

Используй PAF, чтобы задавать более точные вопросы:

- какой product context уже известен;
- какая evidence отсутствует;
- какой artifact нужен следующим;
- какое решение пока не ready.
