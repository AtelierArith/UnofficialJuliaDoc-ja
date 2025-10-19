```julia
herk(uplo, trans, alpha, A)
```

複素配列専用のメソッドです。`alpha*A*A'` または `alpha*A'*A` の [`uplo`](@ref stdlib-blas-uplo) 三角形を、[`trans`](@ref stdlib-blas-trans) に従って返します。
