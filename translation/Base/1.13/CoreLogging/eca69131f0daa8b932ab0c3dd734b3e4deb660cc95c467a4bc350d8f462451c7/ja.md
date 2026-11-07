```julia
disable_logging(level)
```

`level`以下のログレベルのログメッセージをすべて無効にします。この設定は*グローバル*であり、デバッグログを無効にしたときのコストを極めて低く抑えることを目的としています。他の仕組みによって現在無効になっているログを有効にするためには使用できない点に注意してください。

# Examples

```julia
Logging.disable_logging(Logging.Info) # Disable debug and info
```
