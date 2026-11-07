```julia
bunchkaufman_native!(A, rook::Bool=false; check = true) -> BunchKaufman
```

`bunchkaufman_native!`は[`bunchkaufman!`](@ref)と同じですが、LAPACKを呼び出す代わりに、Juliaのネイティブコードで因子分解を実行します。
