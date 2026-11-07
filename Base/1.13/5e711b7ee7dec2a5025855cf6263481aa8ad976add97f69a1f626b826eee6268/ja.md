```julia
isprecompilable(f, argtypes::Tuple{Vararg{Any}})
```

実際にコンパイルせずに可能な範囲で、指定された関数 `f` が、引数タプル（型）`argtypes` に対してコンパイル可能かどうかを確認します。
