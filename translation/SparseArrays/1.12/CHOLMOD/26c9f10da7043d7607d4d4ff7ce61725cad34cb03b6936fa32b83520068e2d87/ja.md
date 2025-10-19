```julia
cholesky!(F::CHOLMOD.Factor, A::SparseMatrixCSC; shift = 0.0, check = true) -> CHOLMOD.Factor
```

`A`のコレスキー ($LL'$) 分解を計算し、シンボリック分解 `F` を再利用します。`A` は [`SparseMatrixCSC`](@ref) または `SparseMatrixCSC` の [`Symmetric`](@ref)/ [`Hermitian`](@ref) ビューでなければなりません。`A` が型タグを持っていなくても、対称またはエルミートである必要があります。

詳細は [`cholesky`](@ref) を参照してください。

!!! note
    このメソッドは、SuiteSparse の CHOLMOD ライブラリを使用しており、実数または複素数の単精度または倍精度の型のみをサポートしています。これらの要素型でない入力行列は、適切にこれらの型に変換されます。

