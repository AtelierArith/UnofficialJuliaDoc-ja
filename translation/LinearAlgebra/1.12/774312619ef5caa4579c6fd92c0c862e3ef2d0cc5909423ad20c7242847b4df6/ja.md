```julia
hermitianpart(A::AbstractMatrix, uplo::Symbol=:U) -> Hermitian
```

正方行列 `A` のエルミート部分を返します。これは `(A + A') / 2` と定義され、[`Hermitian`](@ref) 行列として返されます。実数行列 `A` に対しては、これは `A` の対称部分としても知られています。また、時には「演算子の実部」とも呼ばれます。オプションの引数 `uplo` は、[`Hermitian`](@ref) ビューの対応する引数を制御します。実数行列の場合、後者は [`Symmetric`](@ref) ビューに相当します。

対応するインプレース操作については、[`hermitianpart!`](@ref) も参照してください。

!!! compat "Julia 1.10"
    この関数は Julia 1.10 以降が必要です。

