```julia
hemv(ul, A, x)
```

`A*x`を返します。`A`はエルミート行列であると仮定されます。`A`のうち、[`ul`](@ref stdlib-blas-uplo)側の三角部分のみが使用されます。
