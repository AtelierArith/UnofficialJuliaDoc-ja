```julia
sbmv!(uplo, k, alpha, A, x, beta, y)
```

ベクトル `y` を `alpha*A*x + beta*y` として更新します。ここで、`A` は引数 `A` に格納された `k` 個の上対角線を持つ対称バンド行列で、次数は `size(A,2)` です。`A` のストレージレイアウトは、[https://www.netlib.org/lapack/explore-html/](https://www.netlib.org/lapack/explore-html/) の参照 BLAS モジュール、レベル 2 BLAS で説明されています。`A` の [`uplo`](@ref stdlib-blas-uplo) 三角形のみが使用されます。

更新された `y` を返します。
