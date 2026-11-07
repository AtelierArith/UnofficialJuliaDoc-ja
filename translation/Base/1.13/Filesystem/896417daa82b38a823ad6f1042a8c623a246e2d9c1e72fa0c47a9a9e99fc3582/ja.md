```julia
isfifo(path)::Bool
isfifo(path_elements...)::Bool
isfifo(stat_struct)::Bool
```

`true` を返します。ただし、`path` のファイルまたは `stat_struct` のファイル記述子が FIFO の場合は、`false` を返します。
