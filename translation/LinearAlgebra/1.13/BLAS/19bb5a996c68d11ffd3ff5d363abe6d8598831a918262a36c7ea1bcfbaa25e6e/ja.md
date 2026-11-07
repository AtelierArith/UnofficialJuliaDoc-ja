```julia
sbmv(uplo, k, alpha, A, x)
```

`A` は、`size(A,2)` 次の対称帯行列です。`k` 本の上対角線は、引数 `A` に格納されています。`A` の [`uplo`](@ref stdlib-blas-uplo) 三角部分のみが使用されます。`alpha*A*x`
