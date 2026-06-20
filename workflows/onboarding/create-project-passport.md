# Create Project Passport

## Goal

Create a compact project passport that makes product context, assumptions and
evidence gaps visible.

## Required Inputs

- product or exploration mode;
- target user/segment;
- problem/job;
- current evidence;
- constraints;
- expected decision or artifact.

## Steps

1. Start trace with `tools/run-workflow.ps1 -WorkflowId create_project_passport`.
2. Ask for missing decision-critical context.
3. Draft the passport with facts, assumptions and gaps separated.
4. Label unsupported PMF/PCF/business-impact claims as forbidden.
5. Close trace with artifact refs.

## Output

`[PROJECT PASSPORT]` markdown with evidence gaps.
