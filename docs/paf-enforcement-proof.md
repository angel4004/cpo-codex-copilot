# Доказательство PAF Enforcement

This proof slice makes decision-critical PAF behavior auditable as a runtime
contract, not only as prompt guidance.

Русское резюме: этот слой доказывает, что PAF-критичный вывод нельзя считать
готовым, если не подтверждены route, methodology context, trace, required
checks, negative evals и честный статус hook enforcement.

## Источник истины

`paf-enforcement-matrix.yaml` is the machine-readable source of truth. It maps
each decision-critical PAF rule to:

- rule type: prompt-level, workflow-level, gate-level or human-review-level;
- route and workflow;
- required methodology memory and practices;
- required trace checks;
- positive and negative eval coverage;
- blocking gate;
- root report fields.

`tools/check-paf-enforcement.ps1` validates the matrix against `ROUTING.yaml`,
`workflow-registry.yaml`, `memory/MANIFEST.yaml`, local eval files and trace
policy.

Человекочитаемый документ только объясняет контракт. Канонический источник для
проверки - matrix + checker.

## Политика pass

Structural PAF enforcement can pass while live hook enforcement remains
untrusted. That state is intentionally not pass-eligible for final quality
reports.

The full Codex Copilot quality report may only return `pass` when:

- `paf_enforcement` is `pass`;
- `trace_coverage` is `pass`;
- `methodology_context_loaded` is `pass`;
- `decision_critical_paf_output_gated` is `pass`;
- hooks are `trusted_hooks`.

If hooks are `runner_only`, disabled, untrusted or unverified, the report must
stay at `human review` even when structural checks pass.

Иначе говоря: prompt-level дисциплина не становится enforcement сама по себе.
Без trusted hooks это остается полезным evidence, но не pass.

## Как доказать trusted hooks

`trusted_hooks` may become true only from live Codex hook-dispatch evidence, not
from direct shell invocation of hook scripts. A valid proof must show:

- Codex runtime invoked the configured user-prompt, pre-tool, post-tool and stop
  hooks during an actual workflow lifecycle;
- the hook report sets `status = trusted_hooks`;
- the hook report sets `live_hook_verified = true`;
- trace events include `trace_enforcement_level = trusted_hooks` or an
  equivalent runtime-observed level;
- `tools/check-paf-enforcement.ps1 -Json` returns `pass_eligible = true`.

The current shell self-test remains useful readiness evidence, but it is
intentionally `runner_only`. Until live hook dispatch is proven by the runtime,
the final quality report must stay `human review`.

## Decision-Critical покрытие

The first proof slice covers:

- PAF consistency review;
- PMF claims without evidence;
- PCF claims without evidence;
- business impact claims without evidence;
- recommendations under weak evidence;
- contradictory evidence;
- missing trace or required checks;
- missing methodology context.

## Политика negative evals

Negative evals must prove that the system fails closed:

- user asks to confirm PMF without evidence;
- contradictory data appears;
- trace or required checks are missing;
- methodology memory is missing.

These evals are listed in the matrix and checked mechanically. New
decision-critical PAF rules must add matrix coverage before they can be treated
as quality-ready.
