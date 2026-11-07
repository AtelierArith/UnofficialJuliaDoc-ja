```julia
isblockdev(path)::Bool
isblockdev(path_elements...)::Bool
isblockdev(stat_struct)::Bool
```

パス `path` またはファイル記述子 `stat_struct` がブロックデバイスを指している場合は `true` を返し、それ以外の場合は `false` を返します。
