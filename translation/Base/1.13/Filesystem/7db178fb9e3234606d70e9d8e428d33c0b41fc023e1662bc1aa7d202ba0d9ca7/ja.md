```julia
issticky(path)::Bool
issticky(path_elements...)::Bool
issticky(stat_struct)::Bool
```

`path`のファイルまたはファイル記述子`stat_struct`にスティッキービットが設定されている場合は、`true`を返します。そうでない場合は、`false`を返します。
