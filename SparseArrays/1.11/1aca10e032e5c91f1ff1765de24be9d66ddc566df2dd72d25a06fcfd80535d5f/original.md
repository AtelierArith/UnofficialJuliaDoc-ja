```
unchecked_aliasing_permute!(A::AbstractSparseMatrixCSC{Tv,Ti},
    p::AbstractVector{<:Integer}, q::AbstractVector{<:Integer},
    C::AbstractSparseMatrixCSC{Tv,Ti}, workcolptr::Vector{Ti}) where {Tv,Ti}
```

See [`permute!`](@ref) for basic usage. Parent of `permute!` methods operating on [`SparseMatrixCSC`](@ref)s where the source and destination matrices are the same. See `unchecked_noalias_permute!` for additional information; these methods are identical but for this method's requirement of the additional `workcolptr`, `length(workcolptr) >= size(A, 2) + 1`, which enables efficient handling of the source-destination aliasing.
