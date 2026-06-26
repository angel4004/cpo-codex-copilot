# Goal-led validation - ведение цели

Используй это правило, когда пользователь развивает существующий продукт и дает
измеримую цель: клиенты, revenue, retention, conversion, activation, adoption,
PMF/PCF evidence или deadline.

## Инвариант

Copilot должен вести пользователя к достижению и валидации цели, а не только
создавать familiar artifacts.

## Обязательный first useful output

- `Goal Card`: цель, baseline, deadline, definition of success.
- `Current evidence`: что уже известно и откуда.
- `Artifact Inventory Gate`: какие паспорта, memory, reports или traces уже
  есть; если найдено несколько паспортов, дай `Passport Registry`.
- `Source Routing`: что Copilot может взять сам из разрешенных источников, что
  нужно от пользователя, что недоступно.
- `PAF status`: applied/not applied, evidence level, blocked unsupported claims,
  next evidence needed, enforcement caveat.
- `Next validation artifact`: один следующий artifact/check и критерий, что он
  докажет или опровергнет.
- `Decision after this`: какое конкретное решение станет возможным после
  проверки.

## Passport Registry - реестр паспортов

Если найдено несколько паспортов, не смешивай их. Для каждого укажи:

- `passport`: имя/направление;
- `status`: active / historical / hypothesis;
- `use_for_current_goal`: как используется в текущей цели;
- `do_not_claim`: какие claims нельзя переносить без bridge evidence;
- `next_validation`: какой check нужен.

## Source Routing - маршрутизация источников перед вопросом

Перед просьбой к пользователю прислать данные классифицируй источники:

- `I can check`: разрешенные local/live sources, например memory, amoCRM,
  reports, traces;
- `Need from user`: данные, которых нет в sources или доступ к которым не
  одобрен;
- `Unavailable`: источники без доступа, с privacy/cost/write ограничением или
  требующие отдельного approval.

Если источник доступен read-only, используй его сам или явно скажи, почему не
можешь.

## Validation loop - цикл проверки цели

Каждый goal-led artifact должен завершаться decision checkpoint:

```text
Next validation artifact: ...
Pass/fail: ...
Decision after this: ...
```

Так пользователь видит, куда ведет Copilot и как следующий шаг приближает цель.

`PAF status` в goal-led ответе должен использовать exact mini-template, без
переименования полей:

```text
PAF status:
- Applied/not applied: ...
- Evidence level: ...
- Blocked unsupported claims: ...
- Next evidence needed: ...
- Enforcement caveat: ...
```
