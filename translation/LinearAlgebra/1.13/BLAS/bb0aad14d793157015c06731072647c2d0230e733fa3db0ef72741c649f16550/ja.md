```julia
symm(side, ul, alpha, A, B)
```

`alpha*A*B` または `alpha*B*A` を、[`side`](@ref stdlib-blas-side) に応じて返します。`A` は対称であると仮定します。`A` のうち、[`ul`](@ref stdlib-blas-uplo) 三角形のみを使用します。
