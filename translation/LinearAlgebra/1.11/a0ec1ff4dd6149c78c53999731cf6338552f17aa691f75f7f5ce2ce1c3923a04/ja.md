```
bunchkaufman_native!(A, rook::Bool=false; check = true) -> BunchKaufman
```

`bunchkaufman_native!` は [`bunchkaufman!`](@ref) と同じですが、LAPACK を呼び出すのではなく、ネイティブの Julia コードで因子分解を実行します。
