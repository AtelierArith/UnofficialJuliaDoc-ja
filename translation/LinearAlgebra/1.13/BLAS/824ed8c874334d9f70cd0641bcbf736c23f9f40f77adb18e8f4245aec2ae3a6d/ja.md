```julia
symm!(side, ul, alpha, A, B, beta, C)
```

[`side`](@ref stdlib-blas-side)に従って、`C`を`alpha*A*B + beta*C`または`alpha*B*A + beta*C`に更新します。`A`は対称であると仮定します。`A`のうち、[`ul`](@ref stdlib-blas-uplo)三角形のみを使用します。更新後の`C`を返します。
