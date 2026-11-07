```julia
rowvals(A)
```

疎配列 `A` の行インデックスを格納したベクトルを返します。返されたベクトルを変更すると、`A` も変更されます。行インデックスの内部での格納方法にアクセスできると、構造的な非ゼロ値を反復処理する際に便利です。[`nonzeros`](@ref) および [`nzrange`](@ref) も参照してください。

# Examples

```jldoctest
julia> A = sparse(2I, 3, 3)
3×3 SparseMatrixCSC{Int64, Int64} with 3 stored entries:
 2  ⋅  ⋅
 ⋅  2  ⋅
 ⋅  ⋅  2

julia> rowvals(A)
3-element Vector{Int64}:
 1
 2
 3
```
