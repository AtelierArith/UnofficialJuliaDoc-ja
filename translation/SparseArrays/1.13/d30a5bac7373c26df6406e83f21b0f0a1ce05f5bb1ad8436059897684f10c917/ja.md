```julia
SparseArrays.spzeros!(::Type{Tv}, I, J, [m, n]) -> SparseMatrixCSC{Tv}
```

最終的な行列の格納領域として、入力ベクトル `I` と `J` を再利用する `spzeros!` の変種です。構築後、入力ベクトルは行列のバッファをエイリアスします。`S.colptr === I` と `S.rowval === J` が成り立ち、必要に応じて `resize!` されます。

一部の作業用バッファは引き続き割り当てられる点に注意してください。具体的には、このメソッドは `spzeros!(Tv, I, J, m, n, klasttouch, csrrowptr, csrcolval, csccolptr, cscrowval)` を呼び出す便利なラッパーです。このメソッドは適切なサイズの `klasttouch`、`csrrowptr`、`csrcolval` を割り当てますが、`csccolptr` と `cscrowval` には `I` と `J` を再利用します。

引数 `m` と `n` のデフォルト値は、それぞれ `maximum(I)` と `maximum(J)` です。

!!! compat "Julia 1.10"
    このメソッドには Julia 1.10 以降が必要です。

