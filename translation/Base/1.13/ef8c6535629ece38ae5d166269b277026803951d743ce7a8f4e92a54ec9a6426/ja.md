```julia
wait(t::Task; throw=true)
```

`Task` が完了するまで待ちます。

キーワード `throw`（デフォルトは `true`）は、失敗したタスクの結果をエラーにするかどうかを制御します。エラーは、失敗したタスクをラップする [`TaskFailedException`](@ref) としてスローされます。

デッドロックを防ぐため、現在実行中のタスクが `t` の場合は `ConcurrencyViolationError` をスローします。
