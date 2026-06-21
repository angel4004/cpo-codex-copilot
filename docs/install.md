# Установка и обновление CPO Codex Copilot

Эта инструкция рассчитана на русскоязычного пользователя, который хочет
поставить CPO Copilot локально и запускать его внутри Codex без отдельного API,
сервера или GPT Project.

## Что нужно до установки

- установленный Git;
- установленный Codex;
- доступ к GitHub repo `angel4004/cpo-codex-copilot`;
- локальная папка, где будет лежать workspace.

Отдельные OpenAI API keys для работы Copilot не нужны: Copilot работает внутри
Codex workspace и использует runtime Codex.

## Первая установка

```powershell
git clone https://github.com/angel4004/cpo-codex-copilot.git cpo-codex-copilot
cd cpo-codex-copilot
powershell -NoProfile -File tools/setup-local-workspace.ps1
```

После успешной проверки открой папку `cpo-codex-copilot` в Codex и напиши в чат:

```text
Активируй CPO Copilot
```

Copilot должен ответить по-русски и предложить режим работы:

- onboarding нового продукта;
- создание project passport;
- review/hardening существующего passport;
- evidence gap review;
- PAF consistency review.

## Локальная память

Setup-скрипт создает файлы в `memory/local/` из шаблонов:

- `memory/local/user-profile.md`;
- `memory/local/project-context.md`;
- `memory/local/working-state.md`.

Эти файлы нужны для локального контекста пользователя и проекта. Они ignored by
git и не должны попадать в commit или push. Если файл уже существует, setup его
не перезаписывает.

В локальную память можно писать только то, что допустимо хранить на компьютере
пользователя. Не сохраняй туда API keys, пароли, session tokens, raw private
transcripts или другие secrets.

## Обновление до новой версии

Когда в Git появляется новая версия Copilot:

```powershell
cd cpo-codex-copilot
git pull --ff-only
powershell -NoProfile -File tools/setup-local-workspace.ps1
```

`git pull --ff-only` подтянет tracked инструкции, workflow, practices, checks и
shared memory. Локальная память в `memory/local/` не должна измениться.

## Проверка после установки

Базовая локальная проверка:

```powershell
powershell -NoProfile -File tools/run-smoke.ps1
```

Smoke проверяет структуру workspace, русскоязычный UX, ссылки, routing, memory
metadata, memory conflicts, eval schema, trace coverage, redaction fixtures,
migration coverage и PAF enforcement proof.

Важно: smoke не доказывает полный production pass. Production/full pass требует
отдельного trusted Codex hooks proof и live behavior/protocol verification.

## Что делать при ошибке

Если setup или smoke падает:

1. скопируй в Codex текст ошибки без secrets;
2. напиши, на каком шаге ошибка возникла;
3. попроси: `Проверь установку CPO Copilot и предложи исправление`.

Не удаляй `memory/local/` и не делай `git reset --hard`, пока не понятно, что
именно сломалось.

## Что не нужно делать

- Не используй legacy repo `angel4004/cpo` для Codex Copilot.
- Не коммить `memory/local/`, `traces/local/`, `.env*`, secrets или raw private
  материалы.
- Не меняй `AGENTS.md`, `CONSTITUTION.md`, routing или workflows без локальных
  проверок.
- Не заявляй PAF/live readiness без соответствующего protocol/methodology
  отчета.
