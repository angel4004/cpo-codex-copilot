# Память Atomize проекта

version: 1
vaultType: project
vaultRoot: ./memory
atomicDir: ./memory/atomic
indexFile: ./memory/index.md
globalVault: ~/vault
globalOverride: /atomize global

## Правила

- Храни проектные идеи, backlog notes, product hypotheses, roadmap decisions и project insights в этой памяти проекта.
- Используй global vault только когда пользователь явно просит global capture, например `/atomize global`.
- Перед записью заметки показывай выбранный vault и жди обычный atomize review gate.
- Не храни secrets, credentials, session strings, raw private messages, phone numbers или `.env*` values в atomize notes.
- Не перезаписывай этот файл автоматически; сохраняй проектные правки.
