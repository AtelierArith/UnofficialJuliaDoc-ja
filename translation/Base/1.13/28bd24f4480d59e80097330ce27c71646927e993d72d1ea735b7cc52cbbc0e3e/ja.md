```julia
setdiff(s, itrs...)
```

`s` に含まれ、`itrs` のいずれの反復可能オブジェクトにも含まれない要素からなる集合を構築します。配列を使うと、順序が維持されます。結果の要素型は `s` と同じになります。

関連項目: [`setdiff!`](@ref)、[`union`](@ref)、[`intersect`](@ref)。

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
