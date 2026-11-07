```julia
sparse_hvcat(rows::Tuple{Vararg{Int}}, values...)
```

1 回の呼び出しで、疎な行方向および列方向の連結を行います。この関数はブロック行列構文で呼び出されます。最初の引数には、各ブロック行で連結する引数の数を指定します。

!!! compat "Julia 1.8"
    このメソッドは Julia 1.8 で追加されました。SparseArray 引数がない場合でも、LinearAlgebra.jl の特殊な「sparse」行列型との連結結果が自動的に疎行列になっていた、従来の連結動作を再現します。

