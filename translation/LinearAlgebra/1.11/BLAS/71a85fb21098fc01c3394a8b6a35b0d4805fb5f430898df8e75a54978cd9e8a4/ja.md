```
gemmt(uplo, tA, tB, A, B)
```

指定された [`uplo`](@ref stdlib-blas-uplo) の `A*B` の下三角または上三角部分、または [`tA`](@ref stdlib-blas-trans) と `tB` に応じた他の3つのバリアントを返します。

!!! compat "Julia 1.11"
    `gemmt` は少なくとも Julia 1.11 を必要とします。

