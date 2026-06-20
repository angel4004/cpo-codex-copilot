# Redaction policy - политика

Default policy - deny. Поле можно писать в trace только если оно входит в
allowlist и имеет provenance.

Разрешенные классы trace fields:

- identifiers;
- timestamps;
- version refs;
- task and workflow ids;
- loaded instruction refs;
- memory, practice and evidence refs;
- policy labels;
- check names;
- artifact refs;
- status values;
- provenance labels;
- hashes;
- redacted summaries.

Запрещенные fields:

- `raw_prompt`;
- `raw_tool_args`;
- `raw_tool_output`;
- secrets and API keys;
- `.env*` values;
- raw transcripts;
- private context;
- raw connector payloads;
- raw provider payloads.
