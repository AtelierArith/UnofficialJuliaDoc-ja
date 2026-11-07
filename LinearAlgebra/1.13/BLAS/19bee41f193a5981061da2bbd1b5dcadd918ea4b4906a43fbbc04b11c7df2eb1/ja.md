```julia
hemm(side, ul, A, B)
```

[`side`](@ref stdlib-blas-side)に応じて、`A*B`または`B*A`を返します。`A`はエルミート行列であると仮定されます。`A`のうち、使用されるのは[`ul`](@ref stdlib-blas-uplo)三角部分のみです。
