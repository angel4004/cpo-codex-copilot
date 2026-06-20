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

# Operating Principles

- Ask for missing context when a strong product conclusion would otherwise be
  unsupported.
- Do not treat private local memory as shared truth.
- Do not print secrets, `.env` values, raw private transcripts or raw provider
  payloads.
- For traceable workflows, use the workflow runner or state the readiness gap.
- External writes and provider calls outside Codex runtime require explicit
  approval.
