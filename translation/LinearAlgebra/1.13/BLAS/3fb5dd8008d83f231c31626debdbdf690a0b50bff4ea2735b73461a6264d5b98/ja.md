```julia
symv(ul, alpha, A, x)
```

`alpha*A*x`を返します。`A`は対称であると仮定します。`A`のうち、[`ul`](@ref stdlib-blas-uplo)の三角部分のみを使用します。`alpha`はスカラーです。
