```julia
global_logger()
```

現在のタスクに専用のロガーがない場合にメッセージを受け取る、グローバルロガーを返します。

```julia
global_logger(logger)
```

グローバルロガーを`logger`に設定し、以前のグローバルロガーを返します。
