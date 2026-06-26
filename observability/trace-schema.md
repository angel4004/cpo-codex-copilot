# Trace schema - схема

Минимальные поля event:

- `trace_id`
- `session_id`
- `trace_enforcement_level`
- `timestamp`
- `git_sha`
- `copilot_version`
- `user_task_type`
- `workflow_used`
- `instructions_loaded`
- `memory_refs`
- `practice_refs`
- `evidence_refs`
- `decision_summary`
- `missing_inputs`
- `forbidden_claim_labels`
- `approval_required`
- `approval_state`
- `checks_run`
- `artifact_refs`
- `redaction_policy`
- `final_status`
- `field_provenance`

`artifact_refs`, `evidence_refs` and `checks_run` are arrays. Trace refs must be
stable artifact, file, report, memory or trace refs. Unresolved `chat:` refs and
comma-joined multi refs are invalid. Absolute local paths such as `C:\Users\...`,
`/Users/...` or `/home/...` are invalid in refs and final status; use
repo-relative paths, stable artifact ids or redacted source labels.

For workflows whose `workflow-registry.yaml` entry declares
`required_artifacts`, `tools/close-trace.ps1` must receive both artifact refs and
evidence refs before it can close the trace.

Raw prompt, raw tool args, raw tool output, secrets, transcripts и private
context запрещены как trace fields.
