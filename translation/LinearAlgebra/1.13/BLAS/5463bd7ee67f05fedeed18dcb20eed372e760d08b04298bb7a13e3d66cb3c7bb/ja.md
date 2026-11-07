```julia
sbmv(uplo, k, A, x)
```

`A` が次数 `size(A,2)` の対称帯行列で、`k` 本の上側対角線が引数 `A` に格納されている場合、`A*x` を返します。`A` のうち、[`uplo`](@ref stdlib-blas-uplo) 三角部分のみが使用されます。
