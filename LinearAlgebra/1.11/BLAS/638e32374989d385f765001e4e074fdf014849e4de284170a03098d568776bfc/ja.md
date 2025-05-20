```
gemmt!(uplo, tA, tB, alpha, A, B, beta, C)
```

指定された [`uplo`](@ref stdlib-blas-uplo) の `C` の下三角または上三角部分を `alpha*A*B + beta*C` または [`tA`](@ref stdlib-blas-trans) と `tB` に応じた他のバリアントで更新します。更新された `C` を返します。

!!! compat "Julia 1.11"
    `gemmt!` は少なくとも Julia 1.11 を必要とします。

