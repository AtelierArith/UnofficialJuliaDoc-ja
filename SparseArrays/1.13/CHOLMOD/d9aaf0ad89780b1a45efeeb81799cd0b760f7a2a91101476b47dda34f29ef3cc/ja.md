```julia
cholesky!(F::CHOLMOD.Factor, A::SparseMatrixCSC; shift = 0.0, check = true) -> CHOLMOD.Factor
```

`A` のコレスキー分解（``LL'``）を、シンボリック分解 `F` を再利用して計算します。`A` は、`SparseMatrixCSC` の [`SparseMatrixCSC`](@ref) または [`Symmetric`](@ref)/[`Hermitian`](@ref) ビューでなければなりません。`A` に型タグがない場合は、それ自体が対称行列またはエルミート行列でなければならないことに注意してください。

関連項目: [`cholesky`](@ref)。

!!! note
    このメソッドは SuiteSparse の CHOLMOD ライブラリを使用します。このライブラリがサポートするのは、単精度または倍精度の実数型および複素数型のみです。入力行列の要素型がこれら以外の場合は、適切な型に変換されます。

