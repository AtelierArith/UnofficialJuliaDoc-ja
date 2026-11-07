```julia
trsv!(ul, tA, dA, A, b)
```

`b` を、`A*x = b` の解、または [`tA`](@ref stdlib-blas-trans) と [`ul`](@ref stdlib-blas-uplo) によって決まる他の2つのバリエーションのいずれかで上書きしてください。対角成分の値を読み込むか、すべて1とみなすかは、[`dA`](@ref stdlib-blas-diag) によって決まります。更新後の `b` を返してください。
