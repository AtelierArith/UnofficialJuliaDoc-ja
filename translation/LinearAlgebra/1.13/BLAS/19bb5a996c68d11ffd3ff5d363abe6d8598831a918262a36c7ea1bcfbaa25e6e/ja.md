```julia
sbmv(uplo, k, alpha, A, x)
```

`A` が、引数 `A` に格納された `k` 本の上対角線を持つ `size(A,2)` 次の対称帯行列である場合、`alpha*A*x` を返します。`A` のうち使用されるのは、[`uplo`](@ref stdlib-blas-uplo) 三角部分のみです。
