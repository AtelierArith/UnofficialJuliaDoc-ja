```
unchecked_aliasing_permute!(A::AbstractSparseMatrixCSC{Tv,Ti},
    p::AbstractVector{<:Integer}, q::AbstractVector{<:Integer},
    C::AbstractSparseMatrixCSC{Tv,Ti}, workcolptr::Vector{Ti}) where {Tv,Ti}
```

基本的な使用法については[`permute!`](@ref)を参照してください。ソース行列と宛先行列が同じである[`SparseMatrixCSC`](@ref)に対して動作する`permute!`メソッドの親です。追加情報については`unchecked_noalias_permute!`を参照してください。これらのメソッドは同一ですが、このメソッドの追加の`workcolptr`の要件、`length(workcolptr) >= size(A, 2) + 1`により、ソース-宛先エイリアシングの効率的な処理が可能になります。
