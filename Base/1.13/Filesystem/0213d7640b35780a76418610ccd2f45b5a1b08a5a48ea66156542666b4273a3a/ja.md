```julia
ischardev(path)::Bool
ischardev(path_elements...)::Bool
ischardev(stat_struct)::Bool
```

パス`path`またはファイル記述子`stat_struct`がキャラクタデバイスを指している場合は`true`を返し、そうでない場合は`false`を返します。
