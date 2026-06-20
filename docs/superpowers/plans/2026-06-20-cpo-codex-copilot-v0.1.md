# План реализации CPO Codex Copilot v0.1

> **Для agentic workers:** REQUIRED SUB-SKILL: используй superpowers:subagent-driven-development (recommended) или superpowers:executing-plans и выполняй план task-by-task. Steps используют checkbox (`- [ ]`) syntax for tracking.

**Цель:** собрать первый Git-installable Codex-native CPO Copilot workspace и доказать готовность к controlled dogfood testing.

**Архитектура:** repo является Codex workspace, а не standalone API service. `AGENTS.md` загружает semantic contract, routing, memory manifest, practices, workflows и local memory; PowerShell scripts дают local readiness gates.

**Tech stack:** Markdown, YAML-like tracked contracts, PowerShell local checks, Git.

---

### Task 1: Skeleton и bootloader

**Files:**
- Создать: `AGENTS.md`, `CONSTITUTION.md`, `README.md`, `CHANGELOG.md`, `.gitignore`, `docs/runtime-contract.md`

- [x] Создать repo skeleton и bootloader artifacts.
- [x] Проверить, что `AGENTS.md` называет semantic load order и указывает на runtime contract.

### Task 2: Memory governance - управление памятью

**Files:**
- Создать: `memory/MANIFEST.yaml`, `memory/shared/*.md`, `memory/templates/*.md`, `memory/decisions/*.md`
- Создать: `tools/check-memory-metadata.ps1`, `tools/check-memory-conflicts.ps1`

- [x] Задать tracked/shared/local memory classes и claim keys.
- [x] Добавить mechanical checks для metadata и conflict detection.

### Task 3: Routing и workflows

**Files:**
- Создать: `ROUTING.yaml`, `workflow-registry.yaml`, `practices/**`, `workflows/**`, `tools/check-routing.ps1`

- [x] Привязать каждый supported task type к workflow, memory ids, practices и trace requirement.
- [x] Проверить, что routed workflows и referenced files существуют.

### Task 4: Trace, redaction и provenance

**Files:**
- Создать: `.codex/hooks.json`, `.codex/hooks/*.ps1`, `observability/**`, `tools/*trace*.ps1`, `tools/run-hook-self-test.ps1`

- [x] Добавить local runner-based trace events, redaction allowlist и provenance requirements.
- [x] Честно маркировать live hook verification gaps, когда hooks нельзя доказать.

### Task 5: Migration inventory - инвентаризация

**Files:**
- Создать: `migration/inventory.yaml`, `tools/check-migration-coverage.ps1`

- [x] Классифицировать каждый source file из `../cpo/runtime/core` и `../cpo/runtime/project_setup`.
- [x] Механически проверить inventory coverage.

### Task 6: Evals и smoke gates

**Files:**
- Создать: `evals/**`, `tools/check-structure.ps1`, `tools/check-links.ps1`, `tools/check-eval-schema.ps1`, `tools/run-smoke.ps1`, `tools/safe-local-commit.ps1`

- [x] Добавить structural, protocol, behavior, rubric и redaction fixtures.
- [x] Запустить все local smoke checks и исправить failures.
