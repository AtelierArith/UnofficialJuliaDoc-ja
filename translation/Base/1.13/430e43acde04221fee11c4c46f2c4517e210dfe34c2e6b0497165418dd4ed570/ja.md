```julia
waitany(tasks; throw=true) -> (done_tasks, remaining_tasks)
```

指定されたタスクのうち、少なくとも1つが完了するまで待機します。

`throw` が `true` の場合、完了したタスクのいずれかが例外を発生させて終了すると、`CompositeException` をスローします。

戻り値は2つのタスクベクトルで構成されます。1つ目は完了したタスク、もう1つは未完了のタスクです。

!!! warning
    呼び出すたびに `tasks` のリストを走査し、各タスクと同期する必要があるため、タスクごとに個別のタスクを作成して直列に実行するコードを書く場合と比べて、効率が悪くなる可能性があります。または、代わりに [`waitall(tasks; failfast=true)`](@ref waitall) を使うことも検討してください。


!!! compat "Julia 1.12"
    この関数を使用するには、Julia 1.12 以降が必要です。

