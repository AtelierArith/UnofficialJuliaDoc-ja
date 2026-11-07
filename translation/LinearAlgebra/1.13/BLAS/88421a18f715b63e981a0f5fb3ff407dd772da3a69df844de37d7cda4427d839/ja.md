```julia
syrk(uplo, trans, alpha, A)
```

`A` の上三角部分または下三角部分を返します。どちらを返すかは [`uplo`](@ref stdlib-blas-uplo) に従い、対象は `alpha*A*transpose(A)` または `alpha*transpose(A)*A` です。どちらを対象とするかは [`trans`](@ref stdlib-blas-trans) に従います。
