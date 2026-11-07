```julia
circshift!(a::AbstractVector, shift::Integer)
```

ベクトル `a` のデータを、`shift` 個分だけ循環シフト（回転）します。

# Examples

```jldoctest
julia> circshift!([1, 2, 3, 4, 5], 2)
5-element Vector{Int64}:
 4
 5
 1
 2
 3

julia> circshift!([1, 2, 3, 4, 5], -2)
5-element Vector{Int64}:
 3
 4
 5
 1
 2
```
