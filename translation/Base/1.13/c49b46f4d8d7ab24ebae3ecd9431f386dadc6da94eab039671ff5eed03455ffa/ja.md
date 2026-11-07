```julia
yield(t::Task, arg = nothing)
```

スケジューラを呼び出す前に、ただちに`t`へ譲る、`schedule(t, arg); yield()`の高速な非公平スケジューリング版です。

`t`が現在実行中のタスクである場合、`ConcurrencyViolationError`をスローします。
