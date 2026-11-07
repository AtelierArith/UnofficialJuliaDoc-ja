```julia
pop!(collection) -> item
```

`collection`から要素を1つ取り除いて返します。`collection`が順序付きコンテナの場合は最後の要素を返し、順序なしコンテナの場合は任意の要素を返します。

関連項目: [`popfirst!`](@ref)、[`popat!`](@ref)、[`delete!`](@ref)、[`deleteat!`](@ref)、[`splice!`](@ref)、[`push!`](@ref)。

# Examples

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
