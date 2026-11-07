```julia
trsm!(side, ul, tA, dA, alpha, A, B)
```

`B` を、`A*X = alpha*B` の解、または [`side`](@ref stdlib-blas-side) と [`tA`](@ref stdlib-blas-trans) によって決まる他の 3 つのバリアントのいずれかで上書きします。`A` のうち、[`ul`](@ref stdlib-blas-uplo) の三角部分のみが使用されます。対角要素の値を読み込むか、すべて 1 とみなすかは [`dA`](@ref stdlib-blas-diag) によって決まります。更新後の `B` を返します。
