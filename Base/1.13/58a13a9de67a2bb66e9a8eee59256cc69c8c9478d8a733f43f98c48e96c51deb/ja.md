```julia
symdiff(s, itrs...)
```

渡された集合に含まれる要素の対称差を構築します。`s` が `AbstractSet` でない場合、順序は維持されます。

[`symdiff!`](@ref)、[`setdiff`](@ref)、[`union`](@ref)、[`intersect`](@ref) も参照してください。

# Examples

```jldoctest
julia> symdiff([1,2,3], [3,4,5], [4,5,6])
3-element Vector{Int64}:
 1
 2
 6

julia> symdiff([1,2,1], [2, 1, 2])
Int64[]
```
