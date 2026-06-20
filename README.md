# CPO Codex Copilot - русскоязычный workspace

`cpo-codex-copilot` - Codex-native workspace для CPO Copilot. Установка
сводится к клонированию repo и открытию папки в Codex.

Физический entrypoint для Codex - `AGENTS.md`. Главный смысловой контракт -
`CONSTITUTION.md`. Локальные проверки лежат в `tools/`.

## Установка

```powershell
git clone <repo-url> cpo-codex-copilot
cd cpo-codex-copilot
Copy-Item memory/templates/local-user-profile.template.md memory/local/user-profile.md
Copy-Item memory/templates/local-working-state.template.md memory/local/working-state.md
powershell -NoProfile -File tools/run-smoke.ps1
```

Затем открой папку в Codex и напиши:

```text
Активируй CPO Copilot
```

## Текущий статус

- Архитектура: утверждена.
- Готовность реализации: кандидат v0.1 для локального controlled dogfood.
- Готовность trace: локальный runner и checks доступны; live-выполнение Codex
  hooks должно быть отдельно trusted and verified в локальной установке.
- Готовность русскоязычного UX: проверяется `tools/check-language.ps1`.
- PAF/live behavior readiness: доказывается только отдельным behavior/protocol
  прогоном; structural smoke сам по себе этого не доказывает.

## Граница безопасности

Copilot может читать и редактировать файлы внутри этого workspace. Внешние
отправки, dependency install, push, PR, deploy, provider/API calls вне Codex
runtime, изменения scheduler/secrets и записи в соседние проекты требуют явного
подтверждения человека.
