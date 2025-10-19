```julia
issetgid(path) -> Bool
issetgid(path_elements...) -> Bool
issetgid(stat_struct) -> Bool
```

`path`にあるファイルまたはファイルディスクリプタ`stat_struct`にsetgidフラグが設定されている場合は`true`を返し、そうでない場合は`false`を返します。
