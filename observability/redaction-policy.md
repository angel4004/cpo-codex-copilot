# Redaction Policy

Default policy is deny. A field may be written to trace only if it is in the
allowlist and has provenance.

Allowed trace field classes:

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

Forbidden fields:

- `raw_prompt`;
- `raw_tool_args`;
- `raw_tool_output`;
- secrets and API keys;
- `.env*` values;
- raw transcripts;
- private context;
- raw connector payloads;
- raw provider payloads.
