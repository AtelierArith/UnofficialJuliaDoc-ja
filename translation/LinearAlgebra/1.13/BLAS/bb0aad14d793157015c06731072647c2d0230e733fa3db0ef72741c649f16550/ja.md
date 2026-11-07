```julia
symm(side, ul, alpha, A, B)
```

[`side`](@ref stdlib-blas-side)に応じて、`alpha*A*B`または`alpha*B*A`を返します。`A`は対称であると仮定します。`A`のうち、[`ul`](@ref stdlib-blas-uplo)の三角形のみを使用します。
