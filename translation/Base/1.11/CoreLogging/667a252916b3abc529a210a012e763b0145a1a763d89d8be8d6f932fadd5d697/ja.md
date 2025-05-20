```
disable_logging(level)
```

`level`以下のログレベルのすべてのログメッセージを無効にします。これは*グローバル*設定であり、無効にするとデバッグログが非常に安価になります。

# 例

```julia
Logging.disable_logging(Logging.Info) # デバッグと情報を無効にする
```
