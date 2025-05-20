```
sbmv(uplo, k, alpha, A, x)
```

`alpha*A*x`を返します。ここで、`A`は引数`A`に格納された`k`の上部対角線を持つ順序`size(A,2)`の対称バンド行列です。`A`の[`uplo`](@ref stdlib-blas-uplo)三角形のみが使用されます。
