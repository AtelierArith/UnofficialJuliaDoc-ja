```julia
trmm(side, ul, tA, dA, alpha, A, B)
```

`alpha*A*B`を返すか、[`side`](@ref stdlib-blas-side)と[`tA`](@ref stdlib-blas-trans)によって決まる他の3つのバリアントのいずれかを返します。`A`のうち、使用されるのは[`ul`](@ref stdlib-blas-uplo)の三角部分だけです。対角要素の値を読み取るか、すべて1とみなすかは、[`dA`](@ref stdlib-blas-diag)によって決まります。
