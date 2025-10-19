```julia
precompile(f, argtypes::Tuple{Vararg{Any}})
```

与えられた関数 `f` を引数タプル（型の） `argtypes` に対してコンパイルしますが、実行はしません。
