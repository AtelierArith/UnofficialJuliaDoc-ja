```julia
trmm!(side, ul, tA, dA, alpha, A, B)
```

`B`を、[`side`](@ref stdlib-blas-side)と[`tA`](@ref stdlib-blas-trans)によって決まる`alpha*A*B`またはその他3種類のバリアントのいずれかに更新します。`A`のうち、[`ul`](@ref stdlib-blas-uplo)の三角部分のみが使用されます。対角要素の値を読み取るか、すべて1とみなすかは、[`dA`](@ref stdlib-blas-diag)によって決まります。更新後の`B`を返します。
