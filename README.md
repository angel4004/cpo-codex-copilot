# CPO Codex Copilot - русскоязычный workspace

`cpo-codex-copilot` - Codex-native workspace для CPO Copilot. Установка
сводится к клонированию repo и открытию папки в Codex.

Физический entrypoint для Codex - `AGENTS.md`. Главный смысловой контракт -
`CONSTITUTION.md`. Локальные проверки лежат в `tools/`.

## Быстрый старт

```powershell
git clone https://github.com/angel4004/cpo-codex-copilot.git cpo-codex-copilot
cd cpo-codex-copilot
powershell -NoProfile -File tools/setup-local-workspace.ps1
```

Затем открой папку в Codex и напиши:

```text
Активируй CPO Copilot
```

Подробный сценарий установки, обновления и безопасной локальной памяти:
[docs/install.md](docs/install.md).

## Что делает setup

- создает `memory/local/`, если папки нет;
- копирует локальные шаблоны памяти в `memory/local/`, если файлов еще нет;
- не перезаписывает личную память пользователя;
- запускает `tools/run-smoke.ps1`;
- оставляет локальные memory/traces ignored by git.

## Обновление

```powershell
git pull --ff-only
powershell -NoProfile -File tools/setup-local-workspace.ps1
```

## Текущий статус

- Архитектура: утверждена.
- Готовность реализации: кандидат v0.1 для локального controlled dogfood.
- Готовность trace: локальный runner и checks доступны; live-выполнение Codex
  hooks должно быть отдельно trusted and verified в локальной установке.
- Готовность русскоязычного UX: проверяется `tools/check-language.ps1`.
- PAF/live behavior readiness: доказывается только отдельным behavior/protocol
  прогоном; structural smoke сам по себе этого не доказывает.

## Не используй старый repo

Legacy GPT Project repo `angel4004/cpo` заархивирован и больше не является
основной веткой развития. Для Codex-first Copilot используй только
`angel4004/cpo-codex-copilot`.

## Граница безопасности

Copilot может читать и редактировать файлы внутри этого workspace. Внешние
отправки, dependency install, push, PR, deploy, provider/API calls вне Codex
runtime, изменения scheduler/secrets и записи в соседние проекты требуют явного
подтверждения человека.
