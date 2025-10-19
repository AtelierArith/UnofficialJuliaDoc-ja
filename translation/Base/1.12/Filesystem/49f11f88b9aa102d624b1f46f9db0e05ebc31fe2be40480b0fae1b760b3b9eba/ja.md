```julia
ischardev(path) -> Bool
ischardev(path_elements...) -> Bool
ischardev(stat_struct) -> Bool
```

パス `path` またはファイルディスクリプタ `stat_struct` がキャラクタデバイスを参照している場合は `true` を返し、それ以外の場合は `false` を返します。
