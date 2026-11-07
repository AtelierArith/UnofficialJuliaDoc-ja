```julia
trsv!(ul, tA, dA, A, b)
```

`b`を、`A*x = b`の解、または[`tA`](@ref stdlib-blas-trans)と[`ul`](@ref stdlib-blas-uplo)によって決まる他の2つのバリアントのいずれかで上書きしてください。対角要素の値を読み取るか、すべて1とみなすかは、[`dA`](@ref stdlib-blas-diag)によって決まります。更新後の`b`を返してください。
