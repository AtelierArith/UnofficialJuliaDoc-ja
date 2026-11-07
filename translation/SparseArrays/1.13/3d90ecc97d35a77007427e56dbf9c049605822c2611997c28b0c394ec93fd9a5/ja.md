```julia
unchecked_aliasing_permute!(A::AbstractSparseMatrixCSC{Tv,Ti},
    p::AbstractVector{<:Integer}, q::AbstractVector{<:Integer},
    C::AbstractSparseMatrixCSC{Tv,Ti}, workcolptr::Vector{Ti}) where {Tv,Ti}
```

基本的な使い方については、[`permute!`](@ref)を参照してください。ソース行列と宛先行列が同一である場合に、[`SparseMatrixCSC`](@ref)を操作する`permute!`メソッドの親です。詳しくは`unchecked_noalias_permute!`を参照してください。これらのメソッドは、ソースと宛先のエイリアスを効率的に処理できるようにする追加の`workcolptr`、`length(workcolptr) >= size(A, 2) + 1`が必要である点を除き、このメソッドと同一です。
