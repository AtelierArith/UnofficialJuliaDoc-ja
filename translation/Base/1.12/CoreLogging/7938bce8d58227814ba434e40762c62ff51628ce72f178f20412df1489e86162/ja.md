```julia
global_logger()
```

現在のタスクに特定のロガーが存在しない場合にメッセージを受信するために使用されるグローバルロガーを返します。

```julia
global_logger(logger)
```

グローバルロガーを `logger` に設定し、以前のグローバルロガーを返します。
