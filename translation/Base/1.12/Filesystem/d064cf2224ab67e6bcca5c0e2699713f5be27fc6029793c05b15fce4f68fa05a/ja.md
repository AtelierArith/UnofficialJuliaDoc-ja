```julia
isfifo(path) -> Bool
isfifo(path_elements...) -> Bool
isfifo(stat_struct) -> Bool
```

`path`のファイルまたはファイルディスクリプタ`stat_struct`がFIFOであれば`true`を返し、それ以外の場合は`false`を返します。
