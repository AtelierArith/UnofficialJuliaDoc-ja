```julia
issetuid(path) -> Bool
issetuid(path_elements...) -> Bool
issetuid(stat_struct) -> Bool
```

`path`にあるファイルまたはファイルディスクリプタ`stat_struct`にsetuidフラグが設定されている場合は`true`を返し、そうでない場合は`false`を返します。
