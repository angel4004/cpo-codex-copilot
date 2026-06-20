# Smoke migration coverage - проверка

Критерии pass:

- каждый файл из `../cpo/runtime/core` и `../cpo/runtime/project_setup`
  присутствует в `migration/inventory.yaml`;
- каждый inventory item имеет classification, destination, status и verification
  refs.
