# Trace Schema

Minimum event fields:

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

Raw prompt, raw tool args, raw tool output, secrets, transcripts and private
context are forbidden trace fields.
