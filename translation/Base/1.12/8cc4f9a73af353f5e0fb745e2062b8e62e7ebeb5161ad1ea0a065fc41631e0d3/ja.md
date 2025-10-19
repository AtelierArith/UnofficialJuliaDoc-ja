```julia
wait(t::Task; throw=true)
```

`Task`が終了するのを待ちます。

キーワード `throw`（デフォルトは `true`）は、失敗したタスクがエラーを引き起こすかどうかを制御します。エラーは失敗したタスクをラップした[`TaskFailedException`](@ref)としてスローされます。

`t`が現在実行中のタスクである場合、デッドロックを防ぐために`ConcurrencyViolationError`をスローします。
