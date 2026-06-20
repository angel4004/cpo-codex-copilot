# Smoke trace coverage - проверка

Критерии pass:

- trace schema содержит `trace_enforcement_level`;
- trace provenance schema задает provenance labels;
- redaction policy содержит default-deny allowlist;
- `tools/check-trace-coverage.ps1` завершается с exit 0.
