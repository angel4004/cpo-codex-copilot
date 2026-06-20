# Smoke hook enforcement - проверка

Критерии pass:

- `.codex/hooks.json` существует;
- hook scripts существуют;
- `tools/run-hook-self-test.ps1` пишет readiness report;
- если live hooks нельзя доказать, report содержит `trace_enforcement_disabled`
  или `runner_only`.
