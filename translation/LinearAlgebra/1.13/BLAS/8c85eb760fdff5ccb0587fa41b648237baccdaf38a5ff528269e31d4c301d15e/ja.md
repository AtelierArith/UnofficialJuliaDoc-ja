```julia
symv(ul, A, x)
```

`A*x`を返します。`A`は対称であると仮定されます。[`ul`](@ref stdlib-blas-uplo)の三角部分のみが`A`で使用されます。
