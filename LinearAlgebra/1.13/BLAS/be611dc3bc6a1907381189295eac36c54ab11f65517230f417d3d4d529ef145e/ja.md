```julia
gemv(tA, alpha, A, x)
```

[`tA`](@ref stdlib-blas-trans)に応じて、`alpha*A*x`または`alpha*A'x`を返します。`alpha`はスカラーです。
