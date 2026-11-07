```julia
precompile(f, argtypes::Tuple{Vararg{Any}})
```

指定された関数 `f` を、引数タプル（型）`argtypes` に対してコンパイルします。ただし、実行はしません。
