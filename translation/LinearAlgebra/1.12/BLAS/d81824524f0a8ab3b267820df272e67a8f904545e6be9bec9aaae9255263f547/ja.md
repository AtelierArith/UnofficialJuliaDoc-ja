```julia
hemm(side, ul, A, B)
```

`A*B` または `B*A` を [`side`](@ref stdlib-blas-side) に従って返します。`A` はエルミート行列であると仮定します。`A` の [`ul`](@ref stdlib-blas-uplo) 三角形のみが使用されます。
