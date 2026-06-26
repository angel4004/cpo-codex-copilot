# Trace policy - политика

Trace пишет operational events, а не hidden reasoning.

Traceable workflows требуют:

- workflow id;
- session id;
- trace id;
- trace enforcement level;
- closed trace state;
- decision record, если он требуется `workflow-registry.yaml`.
- stable `artifact_refs` и `evidence_refs`, если workflow declares
  `required_artifacts`.

Если hooks disabled, untrusted или unverified, записывай readiness gap вместо
заявления о полной trace readiness.

`chat:` refs не являются artifact refs. Если нужный output пока существует
только в чате, trace должен честно закрываться как evidence gap или ссылаться на
стабильный generated/report/memory artifact после его создания.

Абсолютные локальные пути не являются safe refs для trace. Если источник лежит в
локальной рабочей области, используй repo-relative путь; если источник внешний
или private, используй redacted source label без `C:\Users\...`, `/Users/...`
или `/home/...`.
