```julia
waitall(tasks; failfast=true, throw=true) -> (done_tasks, remaining_tasks)
```

与えられたすべてのタスクが完了するまで待機します。

`failfast` が `true` の場合、関数は与えられたタスクのうち少なくとも1つが例外によって終了したときに戻ります。`throw` が `true` の場合、完了したタスクの1つが失敗したときに `CompositeException` をスローします。

`failfast` と `throw` のキーワード引数は独立して機能します。`throw=true` のみが指定された場合、この関数はすべてのタスクが完了するまで待機します。

戻り値は2つのタスクベクターから構成されます。最初のベクターは完了したタスクで構成され、もう1つは未完了のタスクで構成されます。
