```julia
sbmv(uplo, k, A, x)
```

`A` は、`k` 本の上対角線を引数 `A` に格納した、次数 `size(A,2)` の対称帯行列です。`A` の [`uplo`](@ref stdlib-blas-uplo) 三角部分のみが使用されます。`A*x` を返します。
