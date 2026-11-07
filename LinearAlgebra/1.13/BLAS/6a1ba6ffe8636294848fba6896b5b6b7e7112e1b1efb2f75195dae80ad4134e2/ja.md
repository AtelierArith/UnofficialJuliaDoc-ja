```julia
trmv(ul, tA, dA, A, b)
```

`op(A)*b`を返します。`op`は[`tA`](@ref stdlib-blas-trans)によって決まります。[`ul`](@ref stdlib-blas-uplo)の三角部分のみが`A`に使用されます。[`dA`](@ref stdlib-blas-diag)によって、対角要素の値を読み取るか、すべて1とみなすかが決まります。
