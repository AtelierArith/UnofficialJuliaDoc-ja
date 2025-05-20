```
pop!(collection) -> item
```

`collection` からアイテムを削除し、それを返します。`collection` が順序付きコンテナの場合、最後のアイテムが返されます; 順序なしコンテナの場合は、任意の要素が返されます。

参照: [`popfirst!`](@ref), [`popat!`](@ref), [`delete!`](@ref), [`deleteat!`](@ref), [`splice!`](@ref), および [`push!`](@ref).

# 例

```jldoctest
julia> A=[1, 2, 3]
3-element Vector{Int64}:
 1
 2
 3

julia> pop!(A)
3

julia> A
2-element Vector{Int64}:
 1
 2

julia> S = Set([1, 2])
Set{Int64} with 2 elements:
  2
  1

julia> pop!(S)
2

julia> S
Set{Int64} with 1 element:
  1

julia> pop!(Dict(1=>2))
1 => 2
```
