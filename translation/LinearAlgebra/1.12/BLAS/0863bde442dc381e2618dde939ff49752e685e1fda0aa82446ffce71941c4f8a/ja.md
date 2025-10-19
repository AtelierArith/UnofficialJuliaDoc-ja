```julia
hemv(ul, A, x)
```

`A*x`を返します。`A`はエルミート行列であると仮定されます。`A`の[`ul`](@ref stdlib-blas-uplo)三角部分のみが使用されます。
