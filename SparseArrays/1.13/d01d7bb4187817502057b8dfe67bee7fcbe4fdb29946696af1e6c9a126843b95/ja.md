```julia
sparse_vcat(A...)
```

次元 1 に沿って連結します。SparseMatrixCSC オブジェクトを返します。

!!! compat "Julia 1.8"
    このメソッドは Julia 1.8 で追加されました。SparseArray 引数がなくても、LinearAlgebra.jl の特殊な「sparse」行列型との連結結果が自動的に疎行列になっていた、従来の連結動作を再現します。

