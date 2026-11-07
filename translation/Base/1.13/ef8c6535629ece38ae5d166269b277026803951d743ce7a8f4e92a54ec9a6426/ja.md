```julia
wait(t::Task; throw=true)
```

`Task` が完了するまで待ちます。

キーワード `throw`（デフォルトは `true`）は、タスクが失敗した場合にエラーを発生させるかどうかを制御します。このエラーは、失敗したタスクをラップする [`TaskFailedException`](@ref) としてスローされます。

デッドロックを防ぐため、`t` が現在実行中のタスクである場合は、`ConcurrencyViolationError` をスローします。
