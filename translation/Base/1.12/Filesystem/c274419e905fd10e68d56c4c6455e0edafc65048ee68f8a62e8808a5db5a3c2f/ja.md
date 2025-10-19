```julia
issticky(path) -> Bool
issticky(path_elements...) -> Bool
issticky(stat_struct) -> Bool
```

`path`にあるファイルまたはファイルディスクリプタ`stat_struct`にスティッキービットが設定されている場合は`true`を返し、それ以外の場合は`false`を返します。
