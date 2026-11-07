```julia
gesvx!(fact, trans, A, AF, ipiv, equed, R, C, B) -> (X, equed, R, C, B, rcond, ferr, berr, work)
```

`A` の `LU` 分解を使用して、線形方程式 `A * X = B` (`trans = N`)、`transpose(A) * X = B` (`trans = T`)、または `adjoint(A) * X = B` (`trans = C`) を解きます。`fact` は、`E` の場合、`A` を平衡化して `AF` にコピーします。`F` の場合、以前の `LU` 分解で得られた `AF` と `ipiv` を入力として使用します。`N` の場合、`A` を `AF` にコピーしてから分解します。`fact = F` の場合、`equed` は、`A` が平衡化されていないことを示す `N`、`A` に左から `Diagonal(C)` を乗じたことを示す `C`、`A` に左から `Diagonal(R)` を乗じたことを示す `R`、または `A` に左から `Diagonal(R)`、右から `Diagonal(C)` を乗じたことを示す `B` のいずれかです。`fact = F` かつ `equed = R` または `B` の場合、`R` の要素はすべて正でなければなりません。`fact = F` かつ `equed = C` または `B` の場合、`C` の要素はすべて正でなければなりません。

解 `X` を返します。また、`fact` が `N` でない場合は出力となり、実行された平衡化を示す `equed`、行の平衡化対角行列 `R`、列の平衡化対角行列 `C`、平衡化後の形式 `Diagonal(R)*B` (`trans = N` かつ `equed = R,B` の場合) または `Diagonal(C)*B` (`trans = T,C` かつ `equed = C,B` の場合) で上書きされることがある `B`、平衡化後の `A` の逆条件数 `rcond`、`X` の各解ベクトルに対する前進誤差限界 `ferr`、`X` の各解ベクトルに対する前進誤差限界 `berr`、および逆ピボット成長因子 `work` も返します。
