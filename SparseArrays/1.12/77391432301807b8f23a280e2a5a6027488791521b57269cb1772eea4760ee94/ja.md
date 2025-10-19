```julia
nonzeros(A)
```

スパース配列 `A` の構造的な非ゼロ値のベクトルを返します。これには、スパース配列に明示的に格納されているゼロも含まれます。返されるベクトルは `A` の内部非ゼロストレージを直接指し、返されたベクトルへの変更は `A` も変更します。[`rowvals`](@ref) と [`nzrange`](@ref) を参照してください。

# 例

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
