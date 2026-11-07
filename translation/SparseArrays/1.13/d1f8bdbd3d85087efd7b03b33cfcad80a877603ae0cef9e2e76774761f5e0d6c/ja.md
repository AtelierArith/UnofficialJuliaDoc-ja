```julia
sparse_hcat(A...)
```

次元 2 に沿って連結します。SparseMatrixCSC オブジェクトを返します。

!!! compat "Julia 1.8"
    このメソッドは Julia 1.8 で追加されました。LinearAlgebra.jl の特殊化された「sparse」行列型との連結では、SparseArray 引数がなくても自動的に疎な出力が得られていた、従来の連結動作を再現します。

