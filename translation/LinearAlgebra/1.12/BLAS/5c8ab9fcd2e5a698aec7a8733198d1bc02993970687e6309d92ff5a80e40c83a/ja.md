```julia
gemmt(uplo, tA, tB, A, B)
```

`A*B`の下三角または上三角部分を[`uplo`](@ref stdlib-blas-uplo)で指定されたものとして返すか、[`tA`](@ref stdlib-blas-trans)および`tB`に応じた他の3つのバリアントを返します。

!!! compat "Julia 1.11"
    `gemmt`は少なくともJulia 1.11が必要です。

