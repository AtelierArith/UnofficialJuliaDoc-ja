```julia
trmv!(ul, tA, dA, A, b)
```

`op(A)*b`を返します。`op`は[`tA`](@ref stdlib-blas-trans)によって決まります。`A`のうち、[`ul`](@ref stdlib-blas-uplo)側の三角部分のみが使用されます。対角成分の値を読み取るか、すべて1とみなすかは[`dA`](@ref stdlib-blas-diag)によって決まります。乗算は`b`上でインプレースに行われます。
