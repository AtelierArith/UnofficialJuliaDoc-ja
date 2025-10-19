```julia
her2k(uplo, trans, A, B)
```

`A*B' + B*A'` または `A'*B + B'*A` の [`uplo`](@ref stdlib-blas-uplo) 三角形を返します。これは [`trans`](@ref stdlib-blas-trans) に従います。
