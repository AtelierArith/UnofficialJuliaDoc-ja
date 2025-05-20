```
sparse_vcat(A...)
```

次元1に沿って連結します。SparseMatrixCSCオブジェクトを返します。

!!! compat "Julia 1.8"
    このメソッドはJulia 1.8で追加されました。これは、LinearAlgebra.jlからの特化された「スパース」行列タイプとの連結が、SparseArray引数がない場合でも自動的にスパース出力を生成する以前の連結動作を模倣します。

