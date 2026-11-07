```julia
findall(A)
```

`A` の `true` インデックスまたはキーのベクトル `I` を返します。該当する `A` 要素がない場合は、空の配列を返します。他の種類の値を検索するには、述語を第1引数として渡してください。

インデックスまたはキーの型は、[`keys(A)`](@ref) および [`pairs(A)`](@ref) が返すものと同じです。

関連項目: [`findfirst`](@ref)、[`searchsorted`](@ref)。

# Examples

```jldoctest
julia> A = [true, false, false, true]
4-element Vector{Bool}:
 1
 0
 0
 1

julia> findall(A)
2-element Vector{Int64}:
 1
 4

julia> A = [true false; false true]
2×2 Matrix{Bool}:
 1  0
 0  1

julia> findall(A)
2-element Vector{CartesianIndex{2}}:
 CartesianIndex(1, 1)
 CartesianIndex(2, 2)

julia> findall(falses(3))
Int64[]
```
