```
halfperm!(X::AbstractSparseMatrixCSC{Tv,Ti}, A::AbstractSparseMatrixCSC{TvA,Ti},
          q::AbstractVector{<:Integer}, f::Function = identity) where {Tv,TvA,Ti}
```

列を入れ替え、`A`を転置し、同時に`A`の各エントリに`f`を適用し、その結果`(f(A)Q)^T`（`map(f, transpose(A[:,q]))`）を`X`に格納します。

`X`の要素型`Tv`は`f(::TvA)`と一致しなければなりません。ここで、`TvA`は`A`の要素型です。`X`の次元は`transpose(A)`の次元と一致しなければならず（`size(X, 1) == size(A, 2}`および`size(X, 2) == size(A, 1)`）、`X`は`A`のすべての割り当てられたエントリを収容できるだけのストレージを持っていなければなりません（`length(rowvals(X)) >= nnz(A}`および`length(nonzeros(X)) >= nnz(A)`）。列の入れ替え`q`の長さは`A`の列数と一致しなければなりません（`length(q) == size(A, 2)`）。

このメソッドは、[`SparseMatrixCSC`](@ref)に対する転置および入れ替え操作を実行するいくつかのメソッドの親です。このメソッドは引数のチェックを行わないため、直接使用するのではなく、安全な子メソッド（`[c]transpose[!]`、`permute[!]`）を使用することをお勧めします。

このメソッドは、F. Gustavsonによって記述された`HALFPERM`アルゴリズムを実装しています。「スパース行列のための2つの高速アルゴリズム：乗算と入れ替え転置」、ACM TOMS 4(3)、250-269 (1978)。このアルゴリズムは`O(size(A, 1), size(A, 2), nnz(A))`の時間で実行され、渡されたもの以外のスペースは必要ありません。
