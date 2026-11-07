```julia
hemm(side, ul, alpha, A, B)
```

[`side`](@ref stdlib-blas-side)に応じて、`alpha*A*B`または`alpha*B*A`を返します。`A`はエルミート行列であると仮定されます。`A`のうち、[`ul`](@ref stdlib-blas-uplo)側の三角部分のみが使用されます。
