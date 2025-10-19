```julia
symv(ul, alpha, A, x)
```

`alpha*A*x`を返します。`A`は対称であると仮定されます。`A`の[`ul`](@ref stdlib-blas-uplo)三角形のみが使用されます。`alpha`はスカラーです。
