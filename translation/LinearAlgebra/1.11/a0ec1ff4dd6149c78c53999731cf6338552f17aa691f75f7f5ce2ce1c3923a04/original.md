```
bunchkaufman_native!(A, rook::Bool=false; check = true) -> BunchKaufman
```

`bunchkaufman_native!` is the same as [`bunchkaufman!`](@ref), but it performs the factorization in native Julia code instead of calling LAPACK.
