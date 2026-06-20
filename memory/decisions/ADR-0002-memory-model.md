# ADR-0002: Memory Model

## Status

Accepted.

## Decision

Shared memory is tracked and curated. Local memory is ignored and belongs to the
person using the workspace. `memory/MANIFEST.yaml` owns authority, sensitivity,
load rules and claim keys.

## Rationale

The Copilot needs durable context without leaking private user or project data
into Git. Claim keys make conflict detection mechanically possible.
