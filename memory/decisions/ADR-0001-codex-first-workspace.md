# ADR-0001: Codex-First Workspace

## Status

Accepted.

## Decision

CPO Copilot v0.1 is implemented as a Git-installable Codex workspace, not as a
standalone API service or GPT Project package.

## Rationale

Codex provides local filesystem access, project instructions, hooks and local
verification scripts. This makes the Copilot easier to install, audit and evolve
through Git.
