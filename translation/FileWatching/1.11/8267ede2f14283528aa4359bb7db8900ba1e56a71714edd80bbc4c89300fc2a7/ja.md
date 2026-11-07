```julia
unwatch_folder(path::AbstractString)
```

`path` の変更に対するバックグラウンド追跡を停止します。同じパスで `watch_folder` の返却を待っている別のタスクがある場合、結果が予測できなくなる可能性があるため、この操作は推奨されません。
