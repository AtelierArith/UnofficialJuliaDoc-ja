```julia
hermitianpart(A::AbstractMatrix, uplo::Symbol=:U) -> Hermitian
```

正方行列 `A` のエルミート部分を、`(A + A') / 2` として定義し、[`Hermitian`](@ref) 行列として返します。実行列 `A` の場合、これは `A` の対称部分とも呼ばれます。また、「作用素の実部」と呼ばれることもあります。省略可能な引数 `uplo` は、[`Hermitian`](@ref) ビューの対応する引数を制御します。実行列の場合、後者は [`Symmetric`](@ref) ビューと同等です。

対応するインプレース操作については、[`hermitianpart!`](@ref) も参照してください。

!!! compat "Julia 1.10"
    この関数を使用するには、Julia 1.10 以降が必要です。

