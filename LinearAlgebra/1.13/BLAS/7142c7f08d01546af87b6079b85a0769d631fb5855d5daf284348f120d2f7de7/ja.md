```julia
trsv(ul, tA, dA, A, b)
```

`A*x = b`の解、または[`tA`](@ref stdlib-blas-trans)と[`ul`](@ref stdlib-blas-uplo)によって決まる他の2つのバリアントのいずれかを返します。対角成分を読み込むか、すべて1とみなすかは[`dA`](@ref stdlib-blas-diag)によって決まります。
