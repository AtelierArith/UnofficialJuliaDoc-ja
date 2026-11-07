```julia
issetuid(path)::Bool
issetuid(path_elements...)::Bool
issetuid(stat_struct)::Bool
```

`true` を返します。ただし、`path` のファイルまたはファイル記述子 `stat_struct` に setuid フラグが設定されている場合に限ります。設定されていない場合は `false` を返します。
