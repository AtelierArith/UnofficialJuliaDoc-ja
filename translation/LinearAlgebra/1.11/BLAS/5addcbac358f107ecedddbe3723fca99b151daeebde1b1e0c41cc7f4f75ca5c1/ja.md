```
spr!(uplo, α, x, AP)
```

行列 `A` を `A+α*x*x'` として更新します。ここで、`A` はパック形式の対称行列であり、`x` はベクトルです。

`uplo = 'U'` の場合、配列 AP は対称行列の上三角部分を列ごとに順番に格納している必要があります。したがって、`AP[1]` には `A[1, 1]` が含まれ、`AP[2]` と `AP[3]` にはそれぞれ `A[1, 2]` と `A[2, 2]` が含まれます。

`uplo = 'L'` の場合、配列 AP は対称行列の下三角部分を列ごとに順番に格納している必要があります。したがって、`AP[1]` には `A[1, 1]` が含まれ、`AP[2]` と `AP[3]` にはそれぞれ `A[2, 1]` と `A[3, 1]` が含まれます。

スカラー入力 `α` は実数でなければなりません。

配列入力 `x` と `AP` はすべて `Float32` または `Float64` 型でなければなりません。更新された `AP` を返します。

!!! compat "Julia 1.8"
    `spr!` は少なくとも Julia 1.8 が必要です。

