```
syr!(uplo, alpha, x, A)
```

ベクトル `x` を用いて対称行列 `A` のランク1更新を行います。これは `alpha*x*transpose(x) + A` です。[`uplo`](@ref stdlib-blas-uplo) は `A` のどちらの三角形が更新されるかを制御します。`A` を返します。
