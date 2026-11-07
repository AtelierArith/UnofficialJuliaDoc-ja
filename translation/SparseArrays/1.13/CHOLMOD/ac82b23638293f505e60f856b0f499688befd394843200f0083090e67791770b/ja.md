```julia
ldlt!(F::CHOLMOD.Factor, A::SparseMatrixCSC; shift = 0.0, check = true) -> CHOLMOD.Factor
```

`F` のシンボリック分解を再利用して、`A` の ``LDL'`` 分解を計算します。`A` は、`SparseMatrixCSC` の [`SparseMatrixCSC`](@ref) または [`Symmetric`](@ref)/[`Hermitian`](@ref) ビューでなければなりません。`A` に型タグがない場合、それ自体が対称行列またはエルミート行列でなければならない点に注意してください。

関連項目: [`ldlt`](@ref)。

!!! note
    このメソッドは、[SuiteSparse](https://github.com/DrTimothyAldenDavis/SuiteSparse) の CHOLMOD ライブラリを使用します。このライブラリがサポートするのは、単精度または倍精度の実数型および複素数型のみです。要素型がこれらに該当しない入力行列は、適切な型に変換されます。

