```julia
dropstored!(A::AbstractSparseMatrixCSC, I::AbstractVector{<:Integer}, J::AbstractVector{<:Integer})
```

`(i,j)`ごとに、`i in I`と`j in J`の場合、`A[i,j]`が保存されていれば、`A`から`A[i,j]`のエントリを削除し、保存されていなければ何もしません。派生形：

```julia
dropstored!(A::AbstractSparseMatrixCSC, i::Integer, J::AbstractVector{<:Integer})
dropstored!(A::AbstractSparseMatrixCSC, I::AbstractVector{<:Integer}, j::Integer)
```

# Examples

```jldoctest
julia> A = sparse(Diagonal([1, 2, 3, 4]))
4×4 SparseMatrixCSC{Int64, Int64} with 4 stored entries:
 1  ⋅  ⋅  ⋅
 ⋅  2  ⋅  ⋅
 ⋅  ⋅  3  ⋅
 ⋅  ⋅  ⋅  4

julia> SparseArrays.dropstored!(A, [1, 2], [1, 1])
4×4 SparseMatrixCSC{Int64, Int64} with 3 stored entries:
 ⋅  ⋅  ⋅  ⋅
 ⋅  2  ⋅  ⋅
 ⋅  ⋅  3  ⋅
 ⋅  ⋅  ⋅  4
```
