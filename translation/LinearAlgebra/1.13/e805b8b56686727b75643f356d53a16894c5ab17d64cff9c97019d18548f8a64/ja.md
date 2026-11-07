```julia
bunchkaufman_native!(A, rook::Bool=false; check = true) -> BunchKaufman
```

`bunchkaufman_native!` は [`bunchkaufman!`](@ref) と同じですが、LAPACK を呼び出す代わりに、Julia のネイティブコードで因子分解を実行します。
