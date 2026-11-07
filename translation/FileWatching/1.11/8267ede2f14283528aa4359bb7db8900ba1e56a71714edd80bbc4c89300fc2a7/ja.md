```julia
unwatch_folder(path::AbstractString)
```

`path` の変更に対するバックグラウンド追跡を停止します。同じパスで別のタスクが `watch_folder` の返却を待っている間は、予期しない結果になる可能性があるため、この操作は推奨されません。
