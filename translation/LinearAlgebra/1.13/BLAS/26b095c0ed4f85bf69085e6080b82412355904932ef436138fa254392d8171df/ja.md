```julia
symm(side, ul, A, B)
```

[`side`](@ref stdlib-blas-side)に応じて、`A*B`または`B*A`を返します。`A`は対称であると仮定します。`A`のうち、[`ul`](@ref stdlib-blas-uplo)三角部分のみを使用します。
