```julia
rowvals(A)
```

スパース配列 `A` の行インデックスのベクトルを返します。返されたベクトルに対する変更は、`A` も変更します。行インデックスが内部でどのように格納されているかにアクセスすることは、構造的な非ゼロ値を反復処理する際に便利です。`[`nonzeros`](@ref)` および `[`nzrange`](@ref)` も参照してください。

# 例

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
