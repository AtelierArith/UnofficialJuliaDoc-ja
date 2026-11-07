```julia
nonzeros(A)
```

疎配列 `A` に構造上格納されている非ゼロ値をベクトルとして返します。これには、疎配列に明示的に格納されたゼロも含まれます。返されるベクトルは、`A` の内部の非ゼロ値ストレージを直接参照するため、返されたベクトルを変更すると `A` も変更されます。[`rowvals`](@ref) および [`nzrange`](@ref) を参照してください。

# Examples

```jldoctest
julia> A = sparse(2I, 3, 3)
3×3 SparseMatrixCSC{Int64, Int64} with 3 stored entries:
 2  ⋅  ⋅
 ⋅  2  ⋅
 ⋅  ⋅  2

julia> nonzeros(A)
3-element Vector{Int64}:
 2
 2
 2
```
