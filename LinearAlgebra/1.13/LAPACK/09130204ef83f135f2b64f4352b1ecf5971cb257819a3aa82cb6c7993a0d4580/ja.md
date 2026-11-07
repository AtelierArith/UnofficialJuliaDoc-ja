```julia
gesvx!(fact, trans, A, AF, ipiv, equed, R, C, B) -> (X, equed, R, C, B, rcond, ferr, berr, work)
```

`A` の `LU` 分解を用いて、線形方程式 `A * X = B` (`trans = N`)、`transpose(A) * X = B` (`trans = T`)、または `adjoint(A) * X = B` (`trans = C`) を解きます。`fact` は、`E` の場合、`A` を平衡化して `AF` にコピーします。`F` の場合は、以前の `LU` 分解で得られた `AF` と `ipiv` が入力となります。`N` の場合は、`A` を `AF` にコピーしてから分解します。`fact = F` の場合、`equed` は、`N`（`A` が平衡化されていないことを示す）、`R`（`A` に左から `Diagonal(R)` を乗じたことを示す）、`C`（`A` に右から `Diagonal(C)` を乗じたことを示す）、または `B`（`A` に左から `Diagonal(R)`、右から `Diagonal(C)` を乗じたことを示す）のいずれかです。`fact = F` かつ `equed = R` または `B` の場合、`R` の要素はすべて正でなければなりません。`fact = F` かつ `equed = C` または `B` の場合、`C` の要素はすべて正でなければなりません。

解は `X` として返されます。また、`fact` が `N` でない場合は出力となり、実行された平衡化を示す `equed`、行の平衡化対角行列 `R`、列の平衡化対角行列 `C`、平衡化後の形式 `Diagonal(R)*B` で上書きされる場合がある `B`（`trans = N` かつ `equed = R,B` の場合）、または `Diagonal(C)*B`（`trans = T,C` かつ `equed = C,B` の場合）、平衡化後の `A` の逆条件数 `rcond`、`X` 内の各解ベクトルの前進誤差限界 `ferr`、`X` 内の各解ベクトルの前進誤差限界 `berr`、および逆ピボット成長因子 `work` も返されます。
