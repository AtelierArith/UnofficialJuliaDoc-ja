```julia
gemmt!(uplo, tA, tB, alpha, A, B, beta, C)
```

[`uplo`](@ref stdlib-blas-uplo)で指定された`C`の下三角部分または上三角部分を、[`tA`](@ref stdlib-blas-trans)および`tB`に従って、`alpha*A*B + beta*C`またはその他のバリアントとして更新します。更新後の`C`を返します。

!!! compat "Julia 1.11"
    `gemmt!`にはJulia 1.11以降が必要です。

