```julia
issetuid(path)::Bool
issetuid(path_elements...)::Bool
issetuid(stat_struct)::Bool
```

`true` を返します。ただし、`path` のファイルまたは `stat_struct` のファイル記述子に setuid フラグが設定されている場合に限ります。そうでない場合は `false` を返します。
