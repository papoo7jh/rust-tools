# Development

## run image

create local-network (optionnal - put in comment if not needed)

```yaml
  local-network:
    driver: bridge
```

```shell
docker run --name rust-tools --restart always ymk1/rust-tools bash
```
