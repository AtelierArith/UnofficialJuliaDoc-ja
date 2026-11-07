```julia
symm!(side, ul, alpha, A, B, beta, C)
```

`C`を、[`side`](@ref stdlib-blas-side)に従って`alpha*A*B + beta*C`または`alpha*B*A + beta*C`に更新します。`A`は対称であると仮定します。`A`のうち、[`ul`](@ref stdlib-blas-uplo)の三角部分のみを使用します。更新後の`C`を返します。
