```julia
her!(uplo, alpha, x, A)
```

複素数配列専用のメソッドです。ベクトル `x` を用いて、エルミート行列 `A` を `alpha*x*x' + A` としてランク1更新します。[`uplo`](@ref stdlib-blas-uplo) によって、`A` のどちらの三角部分を更新するかが決まります。`A` を返します。
