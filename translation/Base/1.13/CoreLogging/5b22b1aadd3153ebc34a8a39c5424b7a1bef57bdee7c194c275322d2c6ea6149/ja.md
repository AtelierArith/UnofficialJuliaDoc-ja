```julia
global_logger()
```

現在のタスクに固有のロガーが存在しない場合にメッセージを受け取るために使用される、グローバルロガーを返します。

```julia
global_logger(logger)
```

グローバルロガーを`logger`に設定し、以前のグローバルロガーを返します。
