## Salt States: Game Formula

### Requirements

This formula requires the following additional formulas:

```yaml
  dependencies:
    - name: docker
      repo: git
      source: https://gitlab.dylanwilson.dev/infrastructure/salt-formulas/docker-formula.git
    - name: letsencrypt
      repo: git
      source: https://gitlab.dylanwilson.dev/infrastructure/salt-formulas/letsencrypt-formula.git
    - name: web
      repo: git
      branch: main
      source: https://gitlab.dylanwilson.dev/infrastructure/salt-states/web-states.git
```
