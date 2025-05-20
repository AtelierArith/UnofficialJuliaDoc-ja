```
SparseArrays.sparse!(I, J, V, [m, n, combine]) -> SparseMatrixCSC
```

入力ベクトル（`I`、`J`、`V`）を最終的な行列ストレージに再利用する`sparse!`のバリアントです。構築後、入力ベクトルは行列バッファをエイリアスします。`S.colptr === I`、`S.rowval === J`、および`S.nzval === V`が成り立ち、必要に応じて`resize!`されます。

いくつかの作業バッファはまだ割り当てられることに注意してください。具体的には、このメソッドは`sparse!(I, J, V, m, n, combine, klasttouch, csrrowptr, csrcolval, csrnzval, csccolptr, cscrowval, cscnzval)`の便利なラッパーであり、このメソッドは適切なサイズの`klasttouch`、`csrrowptr`、`csrcolval`、および`csrnzval`を割り当てますが、`csccolptr`、`cscrowval`、および`cscnzval`には`I`、`J`、および`V`を再利用します。

引数`m`、`n`、および`combine`はそれぞれ`maximum(I)`、`maximum(J)`、および`+`にデフォルト設定されています。

!!! compat "Julia 1.10"
    このメソッドはJuliaバージョン1.10以降を必要とします。

