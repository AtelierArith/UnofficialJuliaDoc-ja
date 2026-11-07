```julia
trsm(side, ul, tA, dA, alpha, A, B)
```

`A*X = alpha*B`の解、または[`side`](@ref stdlib-blas-side)と[`tA`](@ref stdlib-blas-trans)によって決まる他の3つのバリアントのいずれかを返します。`A`の[`ul`](@ref stdlib-blas-uplo)三角部分のみが使用されます。対角要素の値を読み込むか、すべて1とみなすかは[`dA`](@ref stdlib-blas-diag)によって決まります。
