```
hermitianpart!(A::AbstractMatrix, uplo::Symbol=:U) -> Hermitian
```

正方行列 `A` をそのエルミート部分 `(A + A') / 2` でインプレースで上書きし、[`Hermitian(A, uplo)`](@ref) を返します。実数行列 `A` に対して、これは `A` の対称部分としても知られています。

対応するアウトオブプレース操作については、[`hermitianpart`](@ref) を参照してください。

!!! compat "Julia 1.10"
    この関数は Julia 1.10 以降が必要です。

