# Retention policy - политика

Generated trace artifacts локальны и ignored by Git.

Default retention:

- `traces/local/`: 30 days;
- `traces/reports/`: 90 days;
- `traces/state/`: 14 days;
- failed trace coverage artifacts: 90 days.

`tools/prune-traces.ps1` может удалять только generated files внутри `traces/`.
