```julia
gemm!(tA, tB, alpha, A, B, beta, C)
```

Update `C` as `alpha*A*B + beta*C` or the other three variants according to [`tA`](@ref stdlib-blas-trans) and `tB`. Return the updated `C`.
