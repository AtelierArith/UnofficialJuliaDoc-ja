```julia
ftranspose!(X::AbstractSparseMatrixCSC{Tv,Ti}, A::AbstractSparseMatrixCSC{Tv,Ti}, f::Function) where {Tv,Ti}
```

`A`を転置し、非ゼロ要素に関数`f`を適用しながら`X`に格納します。`f`によって生成されたゼロは削除されません。`size(X)`は`size(transpose(A))`と等しくなければなりません。必要に応じて`X`のrowvalとnzvalのサイズ変更以外に追加のメモリは割り当てられません。

`halfperm!`を参照してください。
