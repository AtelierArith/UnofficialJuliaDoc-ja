```julia
kill_edge_terminator!(compact::IncrementalCompact, active_bb::Int, from::Int, to::Int)
```

`active_bb` 内のターミネータをコンパクト化する際に、CFG のエッジを削除します。`to` 内のすべての PhiNode ブロック文はすでに処理済みであることを前提とします。そのため、`to == active_bb` の場合、アクティブな BB はコンパクト化されたプレフィックスのみを走査できます。`from` と `to` は、名前変更されていないインデックスです。
