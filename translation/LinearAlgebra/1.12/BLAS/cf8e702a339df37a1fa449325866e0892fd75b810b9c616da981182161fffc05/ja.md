```julia
her!(uplo, alpha, x, A)
```

複素配列専用のメソッド。ベクトル `x` を用いてエルミート行列 `A` のランク1更新を行います。更新は `alpha*x*x' + A` です。[`uplo`](@ref stdlib-blas-uplo) は `A` のどの三角形が更新されるかを制御します。`A` を返します。
