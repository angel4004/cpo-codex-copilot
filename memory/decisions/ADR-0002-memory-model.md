# ADR-0002: Memory model - решение

## Статус

Принято.

## Решение

Shared memory хранится в Git и проходит curated review. Local memory ignored и
принадлежит человеку, который использует workspace. `memory/MANIFEST.yaml`
задает authority, sensitivity, load rules и claim keys.

## Обоснование

Copilot нужен durable context без утечки private user или project data в Git.
Claim keys делают conflict detection механически возможным.
