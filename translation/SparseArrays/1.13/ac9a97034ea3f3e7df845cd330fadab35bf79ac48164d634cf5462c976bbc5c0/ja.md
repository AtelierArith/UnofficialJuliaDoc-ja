```julia
SparseArrays.sparse!(I, J, V, [m, n, combine]) -> SparseMatrixCSC
```

`sparse!`の変種で、最終的な行列の格納に入力ベクトル（`I`、`J`、`V`）を再利用します。構築後、入力ベクトルは行列のバッファをエイリアスします。`S.colptr === I`、`S.rowval === J`、`S.nzval === V`が成立し、必要に応じて`resize!`されます。

一部の作業用バッファは引き続き割り当てられる点に注意してください。具体的には、このメソッドは`sparse!(I, J, V, m, n, combine, klasttouch, csrrowptr, csrcolval, csrnzval, csccolptr, cscrowval, cscnzval)`を呼び出す便利なラッパーです。このメソッドでは、適切なサイズの`klasttouch`、`csrrowptr`、`csrcolval`、`csrnzval`を割り当てる一方、`csccolptr`、`cscrowval`、`cscnzval`には`I`、`J`、`V`を再利用します。

引数`m`、`n`、`combine`のデフォルト値は、それぞれ`maximum(I)`、`maximum(J)`、`+`です。

!!! compat "Julia 1.10"
    このメソッドにはJulia 1.10以降が必要です。

