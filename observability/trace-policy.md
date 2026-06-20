# Trace policy - политика

Trace пишет operational events, а не hidden reasoning.

Traceable workflows требуют:

- workflow id;
- session id;
- trace id;
- trace enforcement level;
- closed trace state;
- decision record, если он требуется `workflow-registry.yaml`.

Если hooks disabled, untrusted или unverified, записывай readiness gap вместо
заявления о полной trace readiness.
