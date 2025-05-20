```
cholesky!(F::CHOLMOD.Factor, A::SparseMatrixCSC; shift = 0.0, check = true) -> CHOLMOD.Factor
```

行列 `A` のコレスキー ($LL'$) 分解を計算し、シンボリック分解 `F` を再利用します。`A` は [`SparseMatrixCSC`](@ref) または [`Symmetric`](@ref)/ [`Hermitian`](@ref) の `SparseMatrixCSC` のビューでなければなりません。`A` が型タグを持っていなくても、対称またはエルミートである必要があります。

詳細は [`cholesky`](@ref) を参照してください。

!!! note
    このメソッドは、SuiteSparse の CHOLMOD ライブラリを使用しており、これは単精度または倍精度の実数または複素数型のみをサポートしています。これらの要素型でない入力行列は、適切にこれらの型に変換されます。

