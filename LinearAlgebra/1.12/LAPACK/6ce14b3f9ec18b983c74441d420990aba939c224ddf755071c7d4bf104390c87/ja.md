```julia
gesvx!(fact, trans, A, AF, ipiv, equed, R, C, B) -> (X, equed, R, C, B, rcond, ferr, berr, work)
```

線形方程式 `A * X = B` (`trans = N`)、`transpose(A) * X = B` (`trans = T`)、または `adjoint(A) * X = B` (`trans = C`) を `A` の `LU` 因子分解を使用して解きます。`fact` は `E` である場合、`A` は平衡化されて `AF` にコピーされます; `F` である場合、`AF` と `ipiv` は以前の `LU` 因子分解からの入力です; または `N` である場合、`A` は `AF` にコピーされ、その後因子分解されます。`fact = F` の場合、`equed` は `N` であり、これは `A` が平衡化されていないことを意味します; `R` は `A` が左から `Diagonal(R)` で乗算されたことを意味します; `C` は `A` が右から `Diagonal(C)` で乗算されたことを意味します; または `B` は `A` が左から `Diagonal(R)` で、右から `Diagonal(C)` で乗算されたことを意味します。`fact = F` で `equed = R` または `B` の場合、`R` の要素はすべて正でなければなりません。`fact = F` で `equed = C` または `B` の場合、`C` の要素はすべて正でなければなりません。

解 `X` を返します; `equed` は `fact` が `N` でない場合の出力であり、実行された平衡化を説明します; `R` は行の平衡化対角行列; `C` は列の平衡化対角行列; `B` はその平衡化された形 `Diagonal(R)*B` で上書きされる可能性があります（`trans = N` かつ `equed = R,B` の場合）または `Diagonal(C)*B`（`trans = T,C` かつ `equed = C,B` の場合）; `rcond` は平衡化後の `A` の逆条件数; `ferr` は `X` の各解ベクトルに対する前方誤差境界; `berr` は `X` の各解ベクトルに対する前方誤差境界; および `work` は逆ピボット成長因子です。
