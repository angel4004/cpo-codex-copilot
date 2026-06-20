# CPO Codex Copilot

`cpo-codex-copilot` is a Codex-native workspace for CPO Copilot. It is installed
by cloning this repository and opening the folder in Codex.

The runtime entrypoint is `AGENTS.md`. The semantic contract is
`CONSTITUTION.md`. Local checks live in `tools/`.

## Install

```powershell
git clone <repo-url> cpo-codex-copilot
cd cpo-codex-copilot
Copy-Item memory/templates/local-user-profile.template.md memory/local/user-profile.md
Copy-Item memory/templates/local-working-state.template.md memory/local/working-state.md
powershell -NoProfile -File tools/run-smoke.ps1
```

Then open the folder in Codex and ask:

```text
Активируй CPO Copilot
```

## Current Status

- Architecture: approved.
- Implementation readiness: v0.1 local controlled dogfood candidate.
- Trace readiness: local runner checks are available; live Codex hook execution
  must be trusted and verified per local install.

## Safety Boundary

The Copilot may read and edit files inside this workspace. External sends,
dependency installs, pushes, PRs, deploys, provider API calls outside Codex
runtime, scheduler changes, secrets changes, and writes to sibling projects
require explicit human approval.
