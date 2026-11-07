```julia
syr!(uplo, alpha, x, A)
```

対称行列 `A` をベクトル `x` で `alpha*x*transpose(x) + A` としてランク1更新します。[`uplo`](@ref stdlib-blas-uplo) は、`A` のどちらの三角部分を更新するかを指定します。`A` を返します。
