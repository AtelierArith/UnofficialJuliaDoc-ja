```julia
setdiff(s, itrs...)
```

`itrs` に含まれるいずれの反復可能オブジェクトにも含まれない、`s` の要素からなる集合を構築します。配列では順序が維持されます。結果の要素型は `s` と同じになります。

[`setdiff!`](@ref)、[`union`](@ref)、[`intersect`](@ref) も参照してください。

# Examples

```jldoctest
julia> setdiff([1,2,3], [3,4,5])
2-element Vector{Int64}:
 1
 2

julia> setdiff([1,2,3], [1.0, 2.0])
1-element Vector{Int64}:
 3
```
