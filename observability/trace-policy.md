# Trace Policy

Trace operational events, not hidden reasoning.

Traceable workflows require:

- workflow id;
- session id;
- trace id;
- trace enforcement level;
- closed trace state;
- decision record when required by `workflow-registry.yaml`.

If hooks are disabled, untrusted or unverified, record the readiness gap instead
of claiming full trace readiness.
