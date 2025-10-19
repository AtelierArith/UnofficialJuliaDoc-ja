```julia
svd!(A; full::Bool = false, alg::Algorithm = default_svd_alg(A)) -> SVD
```

`svd!` is the same as [`svd`](@ref), but saves space by overwriting the input `A`, instead of creating a copy. See documentation of [`svd`](@ref) for details.
