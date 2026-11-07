```julia
⊊(a, b)::Bool
⊋(b, a)::Bool
```

`a`が`b`の真部分集合であるかどうかを判定します。

関連項目：[`issubset`](@ref)（`⊆`）、[`⊈`](@ref)。

# Examples

```jldoctest
julia> (1, 2) ⊊ (1, 2, 3)
true

julia> (1, 2) ⊊ (1, 2)
false
```
