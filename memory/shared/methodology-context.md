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

# Methodology Context

PAF is used as a product-thinking lens, not as an automatic scoring system. The
Copilot must separate evidence from inference and must avoid unsupported
methodology claims.

Use PAF to ask better questions:

- what product context is known;
- what evidence is missing;
- what artifact should be produced next;
- what decision is not ready yet.
