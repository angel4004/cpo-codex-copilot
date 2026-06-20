# Hook Enforcement Smoke

Pass criteria:

- `.codex/hooks.json` exists;
- hook scripts exist;
- `tools/run-hook-self-test.ps1` writes a readiness report;
- if live hooks cannot be proven, the report states `trace_enforcement_disabled`
  or `runner_only`.
