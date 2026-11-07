```julia
trmv(ul, tA, dA, A, b)
```

`op(A)*b`を返します。`op`は[`tA`](@ref stdlib-blas-trans)によって決まります。[`ul`](@ref stdlib-blas-uplo)三角形の`A`のみが使用されます。対角要素の値を読み取るか、すべて1とみなすかは、[`dA`](@ref stdlib-blas-diag)によって決まります。
