```julia
stmts_awaiting_insertion(compact::IncrementalCompact, idx::Int)
```

範囲 `1:idx` 内のいずれかの命令に対して、`compact` への挿入用にキューに入れられた新規または保留中の命令があれば true を返します。それ以外の場合は false を返します。
