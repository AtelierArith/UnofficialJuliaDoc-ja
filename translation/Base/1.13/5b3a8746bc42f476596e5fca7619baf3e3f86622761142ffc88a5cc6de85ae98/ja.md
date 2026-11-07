```julia
waitall(tasks; failfast=true, throw=true) -> (done_tasks, remaining_tasks)
```

指定されたすべてのタスクが完了するまで待機します。

`failfast` が `true` の場合、指定されたタスクのうち少なくとも1つが例外によって終了すると、この関数は戻ります。完了したタスクのいずれかが失敗している場合、`CompositeException` をスローするには、`throw` を `true` に設定します。

キーワード引数 `failfast` と `throw` は独立して機能します。`throw=true` のみを指定した場合、この関数はすべてのタスクが完了するまで待機します。

戻り値は2つのタスクベクトルからなります。1つ目には完了したタスクが、もう1つには未完了のタスクが格納されます。

!!! compat "Julia 1.12"
    この関数を使用するには、Julia 1.12 以降が必要です。

