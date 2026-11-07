```julia
issetgid(path)::Bool
issetgid(path_elements...)::Bool
issetgid(stat_struct)::Bool
```

`true` を返します。`path` のファイルまたは `stat_struct` のファイル記述子に setgid フラグが設定されている場合は `false` を返します。
