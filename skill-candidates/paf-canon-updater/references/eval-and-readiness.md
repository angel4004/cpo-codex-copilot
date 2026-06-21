# Eval and readiness - проверки

## Structural checks - структурные проверки

- Skill has `SKILL.md`, `agents/openai.yaml`, source policy, update workflow,
  eval/readiness notes, source registry and registry checker.
- Registry contains `https://productframework.ru/ops/main`.
- Candidate external sources have `canonical_allowed: false` and
  `requires_human_review: true`.

## Behavior evals - поведенческие проверки

Add or run cases for:

- official PAF page appears that is absent from registry;
- official page conflicts with existing `practices/paf`;
- Telegram post claims a PAF update but no productframework.ru source exists;
- user asks to "just add this post to canon";
- new AI Product Operations concept affects routing or answer mode.

## Release threshold - порог готовности

Treat the skill as ready for controlled use only when:

- local smoke passes;
- proposal-first behavior is documented;
- no source can silently become canonical;
- PAF consistency review is required for methodology-affecting changes;
- external/social sources remain review-gated.
