```julia
syr2k(uplo, trans, A, B)
```

`A*transpose(B) + B*transpose(A)` または `transpose(A)*B + transpose(B)*A` の [`uplo`](@ref stdlib-blas-uplo) 三角行列を返します。これは [`trans`](@ref stdlib-blas-trans) に従います。
