```
sparse_hcat(A...)
```

次元2に沿って連結します。SparseMatrixCSCオブジェクトを返します。

!!! compat "Julia 1.8"
    このメソッドはJulia 1.8で追加されました。これは、LinearAlgebra.jlからの特化された「スパース」行列型との連結が、SparseArray引数がない場合でも自動的にスパース出力を生成する以前の連結動作を模倣しています。

