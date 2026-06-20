# ADR-0001: Codex-first workspace - решение

## Статус

Принято.

## Решение

CPO Copilot v0.1 реализован как Git-installable Codex workspace, а не как
standalone API service или GPT Project package.

## Обоснование

Codex дает local filesystem access, project instructions, hooks и local
verification scripts. Поэтому Copilot проще устанавливать, audit-ить и развивать
через Git.
