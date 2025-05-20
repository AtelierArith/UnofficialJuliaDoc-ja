```
trmv(ul, tA, dA, A, b)
```

`op(A)*b`を返します。ここで、`op`は[`tA`](@ref stdlib-blas-trans)によって決定されます。`A`の[`ul`](@ref stdlib-blas-uplo)三角形のみが使用されます。[`dA`](@ref stdlib-blas-diag)は、対角値が読み取られるか、すべて1であると仮定されるかを決定します。
