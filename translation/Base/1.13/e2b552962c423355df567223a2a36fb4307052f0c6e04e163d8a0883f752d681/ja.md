```julia
BottomRF(rf) -> rf′
```

「Bottom」縮約関数。これは、[`reduce_first`](@ref)を呼び出す最初の呼び出しを処理するために、`foldl`のような関数に渡される`op`引数を薄くラップしたものです。
