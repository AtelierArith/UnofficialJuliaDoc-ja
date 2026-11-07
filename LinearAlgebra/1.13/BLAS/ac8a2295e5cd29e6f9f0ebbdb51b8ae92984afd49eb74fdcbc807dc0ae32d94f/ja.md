```julia
gemmt(uplo, tA, tB, A, B)
```

[`uplo`](@ref stdlib-blas-uplo)で指定された`A*B`の下三角部分または上三角部分を返します。ほかの3つのバリエーションについては、[`tA`](@ref stdlib-blas-trans)と`tB`に従います。

!!! compat "Julia 1.11"
    `gemmt`にはJulia 1.11以降が必要です。

