```julia
waitany(tasks; throw=true) -> (done_tasks, remaining_tasks)
```

指定されたタスクのうち、少なくとも1つが完了するまで待機します。

`throw` が `true` の場合、完了したタスクのいずれかが例外を伴って終了すると、`CompositeException` をスローします。

戻り値は2つのタスクベクトルで構成されます。1つ目は完了したタスク、もう1つは未完了のタスクです。

!!! warning
    呼び出すたびに `tasks` のリストを走査し、各タスクと同期する必要があるため、タスクごとに個別のタスクを作成して直列に実行するコードと比べて、性能が大きく低下する可能性があります。代わりに [`waitall(tasks; failfast=true)`](@ref waitall) の使用も検討してください。


!!! compat "Julia 1.12"
    この関数を使用するには、Julia 1.12 以降が必要です。

