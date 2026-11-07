```julia
trmm(side, ul, tA, dA, alpha, A, B)
```

`alpha*A*B`、または[`side`](@ref stdlib-blas-side)と[`tA`](@ref stdlib-blas-trans)によって決まる、ほかの3つのバリアントのいずれかを返します。`A`のうち、[`ul`](@ref stdlib-blas-uplo)の三角部分だけが使用されます。対角成分の値を読み取るか、すべて1とみなすかは、[`dA`](@ref stdlib-blas-diag)によって決まります。
