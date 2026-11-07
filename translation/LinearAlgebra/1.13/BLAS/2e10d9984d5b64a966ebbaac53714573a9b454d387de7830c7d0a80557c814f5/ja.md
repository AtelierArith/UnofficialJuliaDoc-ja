```julia
trmm!(side, ul, tA, dA, alpha, A, B)
```

`B` を `alpha*A*B`、または [`side`](@ref stdlib-blas-side) と [`tA`](@ref stdlib-blas-trans) によって決まる他の 3 つのバリアントのいずれかとして更新します。`A` のうち、使用されるのは [`ul`](@ref stdlib-blas-uplo) の三角部分だけです。対角成分の値を読み取るか、すべて 1 とみなすかは [`dA`](@ref stdlib-blas-diag) によって決まります。更新後の `B` を返します。
