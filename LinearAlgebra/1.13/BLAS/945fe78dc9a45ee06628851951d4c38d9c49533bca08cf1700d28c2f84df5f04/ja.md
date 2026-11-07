```julia
hemm!(side, ul, alpha, A, B, beta, C)
```

`C`を、[`side`](@ref stdlib-blas-side)に従って`alpha*A*B + beta*C`または`alpha*B*A + beta*C`に更新します。`A`はエルミート行列であると仮定されます。`A`のうち、[`ul`](@ref stdlib-blas-uplo)の三角部分のみが使用されます。更新後の`C`を返します。
