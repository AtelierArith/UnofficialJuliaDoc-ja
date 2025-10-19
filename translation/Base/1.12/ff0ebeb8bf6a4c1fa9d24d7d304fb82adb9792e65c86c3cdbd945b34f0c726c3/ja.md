```julia
findall(A)
```

ベクトル `I` を返し、`A` の `true` インデックスまたはキーを含みます。`A` にそのような要素がない場合は、空の配列を返します。他の種類の値を検索するには、最初の引数として述語を渡します。

インデックスまたはキーは、[`keys(A)`](@ref) および [`pairs(A)`](@ref) によって返されるものと同じ型です。

他にも: [`findfirst`](@ref), [`searchsorted`](@ref).

# 例

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
