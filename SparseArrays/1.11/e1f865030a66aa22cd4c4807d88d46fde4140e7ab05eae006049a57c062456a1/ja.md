```
SparseArrays.spzeros!(::Type{Tv}, I, J, [m, n]) -> SparseMatrixCSC{Tv}
```

入力ベクトル `I` と `J` を最終的な行列ストレージに再利用する `spzeros!` のバリアント。構築後、入力ベクトルは行列バッファをエイリアスします；`S.colptr === I` および `S.rowval === J` が成り立ち、必要に応じて `resize!` されます。

いくつかの作業バッファはまだ割り当てられることに注意してください。具体的には、このメソッドは `spzeros!(Tv, I, J, m, n, klasttouch, csrrowptr, csrcolval, csccolptr, cscrowval)` の便利なラッパーであり、このメソッドは適切なサイズの `klasttouch`、`csrrowptr`、および `csrcolval` を割り当てますが、`csccolptr` と `cscrowval` に `I` と `J` を再利用します。

引数 `m` と `n` はそれぞれ `maximum(I)` と `maximum(J)` にデフォルト設定されています。

!!! compat "Julia 1.10"
    このメソッドは Julia バージョン 1.10 以降を必要とします。

