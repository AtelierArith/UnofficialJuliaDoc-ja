```
symm(side, ul, alpha, A, B)
```

`alpha*A*B` または `alpha*B*A` を [`side`](@ref stdlib-blas-side) に従って返します。`A` は対称であると仮定されます。`A` のみ [`ul`](@ref stdlib-blas-uplo) 三角形が使用されます。
