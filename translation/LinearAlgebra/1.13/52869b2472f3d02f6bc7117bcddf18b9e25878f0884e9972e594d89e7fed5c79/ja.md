```julia
hermitianpart!(A::AbstractMatrix, uplo::Symbol=:U) -> Hermitian
```

正方行列 `A` を、そのエルミート部分 `(A + A') / 2` でインプレースに上書きし、[`Hermitian(A, uplo)`](@ref) を返します。実行列 `A` の場合、これは `A` の対称部分とも呼ばれます。

対応する非インプレース操作については、[`hermitianpart`](@ref) を参照してください。

!!! compat "Julia 1.10"
    この関数を使用するには、Julia 1.10 以降が必要です。

