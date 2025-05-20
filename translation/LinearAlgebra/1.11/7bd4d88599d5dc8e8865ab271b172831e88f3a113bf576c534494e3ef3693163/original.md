```
bunchkaufman!(A, rook::Bool=false; check = true) -> BunchKaufman
```

`bunchkaufman!` is the same as [`bunchkaufman`](@ref), but saves space by overwriting the input `A`, instead of creating a copy.
