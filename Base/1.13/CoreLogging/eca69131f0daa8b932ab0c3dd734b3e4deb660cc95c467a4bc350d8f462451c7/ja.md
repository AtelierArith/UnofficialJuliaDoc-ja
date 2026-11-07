```julia
disable_logging(level)
```

`level` 以下のログレベルのログメッセージをすべて無効にします。この設定は*グローバル*に適用され、デバッグログを無効にしたときのコストを極めて低く抑えることを目的としています。ただし、ほかの仕組みによってすでに無効になっているログを有効にすることはできません。

# Examples

```julia
Logging.disable_logging(Logging.Info) # Disable debug and info
```
