```julia
stmts_awaiting_insertion(compact::IncrementalCompact, idx::Int)
```

`1:idx`の範囲内にあるいずれかの命令に対して、`compact`への挿入待ちの新しい命令がキューに追加されている場合はtrueを返します。それ以外の場合はfalseを返します。
