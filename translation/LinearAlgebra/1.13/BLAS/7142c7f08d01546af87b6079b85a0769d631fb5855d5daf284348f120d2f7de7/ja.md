```julia
trsv(ul, tA, dA, A, b)
```

`A*x = b`、または[`tA`](@ref stdlib-blas-trans)と[`ul`](@ref stdlib-blas-uplo)で決まる他の2つのバリアントのいずれかを返します。対角成分を読み込むか、すべて1とみなすかは、[`dA`](@ref stdlib-blas-diag)で決まります。
