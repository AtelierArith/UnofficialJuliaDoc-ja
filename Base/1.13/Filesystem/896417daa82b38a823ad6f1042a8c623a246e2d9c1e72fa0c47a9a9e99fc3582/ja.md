```julia
isfifo(path)::Bool
isfifo(path_elements...)::Bool
isfifo(stat_struct)::Bool
```

`true` を返します。ただし、`path` のファイルまたはファイル記述子 `stat_struct` が FIFO の場合は、`false` を返します。
