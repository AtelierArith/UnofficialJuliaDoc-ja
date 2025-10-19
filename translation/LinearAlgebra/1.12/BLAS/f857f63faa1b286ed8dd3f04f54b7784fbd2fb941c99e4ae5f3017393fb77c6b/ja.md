```julia
symm!(side, ul, alpha, A, B, beta, C)
```

`C`を`alpha*A*B + beta*C`または`alpha*B*A + beta*C`として更新します。これは[`side`](@ref stdlib-blas-side)に従います。`A`は対称であると仮定されます。`A`の[`ul`](@ref stdlib-blas-uplo)三角形のみが使用されます。更新された`C`を返します。
