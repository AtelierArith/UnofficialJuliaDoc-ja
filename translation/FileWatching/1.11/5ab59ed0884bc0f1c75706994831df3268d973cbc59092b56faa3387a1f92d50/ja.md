```julia
unwatch_folder(path::AbstractString)
```

`path`の変更に対するバックグラウンドトラッキングを停止します。同じパスで`watch_folder`が戻るのを待っている別のタスクがある間にこれを行うことは推奨されません。結果が予測不可能になる可能性があります。
