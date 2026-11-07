```julia
mul!(C::AbstractVecOrMat, tA, tB, A::AbstractVecOrMat, B::AbstractVecOrMat, α::Number, β::Number)
```

行列の転置を行う場合は `B` を `tB` に対応させ、結合された行列積和演算 ``A B α + C β`` (`tA == 'N'`)、``A^⊤ B α + C β`` (`tA == 'T'`)、または ``A' B α + C β`` (`tA == 'C'`) を計算します。結果は `C` に上書き保存されます。`C` は、`A` または `B` とエイリアスになってはならないことに注意してください。

これは、5 引数の [`mul!`](@ref) より下位の抽象化レイヤーです。独自のストレージ型を提供するパッケージでは、5 引数の `mul!` ではなく、このメソッドをオーバーロードすることを推奨します。

!!! compat "Julia 1.13"
    このメソッドには Julia 1.13 以降が必要で、同じシグネチャを持つ非公開の `generic_matmatmul!` メソッドに代わるものです。

