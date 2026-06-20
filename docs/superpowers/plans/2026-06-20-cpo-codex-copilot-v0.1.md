# CPO Codex Copilot v0.1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first Git-installable Codex-native CPO Copilot workspace and prove it is ready for controlled dogfood testing.

**Architecture:** The repo is a Codex workspace, not a standalone API service. `AGENTS.md` bootloads the semantic contract, routing, memory manifest, practices, workflows and local memory; PowerShell scripts provide local readiness gates.

**Tech Stack:** Markdown, YAML-like tracked contracts, PowerShell local checks, Git.

---

### Task 1: Skeleton And Bootloader

**Files:**
- Create: `AGENTS.md`, `CONSTITUTION.md`, `README.md`, `CHANGELOG.md`, `.gitignore`, `docs/runtime-contract.md`

- [x] Create the repo skeleton and bootloader artifacts.
- [x] Verify that `AGENTS.md` names the semantic load order and points to the runtime contract.

### Task 2: Memory Governance

**Files:**
- Create: `memory/MANIFEST.yaml`, `memory/shared/*.md`, `memory/templates/*.md`, `memory/decisions/*.md`
- Create: `tools/check-memory-metadata.ps1`, `tools/check-memory-conflicts.ps1`

- [x] Define tracked/shared/local memory classes and claim keys.
- [x] Add mechanical checks for metadata and conflict detection.

### Task 3: Routing And Workflows

**Files:**
- Create: `ROUTING.yaml`, `workflow-registry.yaml`, `practices/**`, `workflows/**`, `tools/check-routing.ps1`

- [x] Route each supported task type to a workflow, memory ids, practices and trace requirement.
- [x] Verify routed workflows and referenced files exist.

### Task 4: Trace, Redaction And Provenance

**Files:**
- Create: `.codex/hooks.json`, `.codex/hooks/*.ps1`, `observability/**`, `tools/*trace*.ps1`, `tools/run-hook-self-test.ps1`

- [x] Add local runner-based trace events, redaction allowlist and provenance requirements.
- [x] Mark live hook verification gaps honestly when hooks cannot be proven.

### Task 5: Migration Inventory

**Files:**
- Create: `migration/inventory.yaml`, `tools/check-migration-coverage.ps1`

- [x] Classify every source file from `../cpo/runtime/core` and `../cpo/runtime/project_setup`.
- [x] Verify inventory coverage mechanically.

### Task 6: Evals And Smoke Gates

**Files:**
- Create: `evals/**`, `tools/check-structure.ps1`, `tools/check-links.ps1`, `tools/check-eval-schema.ps1`, `tools/run-smoke.ps1`, `tools/safe-local-commit.ps1`

- [x] Add structural, protocol, behavior, rubric and redaction fixtures.
- [x] Run all local smoke checks and fix failures.
