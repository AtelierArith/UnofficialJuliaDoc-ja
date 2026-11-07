```julia
sparse_vcat(A...)
```

次元 1 に沿って連結します。SparseMatrixCSC オブジェクトを返します。

!!! compat "Julia 1.8"
    このメソッドは Julia 1.8 で追加されました。LinearAlgebra.jl の特殊な「sparse」行列型との連結では、SparseArray 引数がなくても自動的に疎な出力が得られていた従来の動作を再現します。

