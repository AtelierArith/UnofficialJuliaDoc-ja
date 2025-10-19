```julia
⊊(a, b) -> Bool
⊋(b, a) -> Bool
```

`a`が`b`の部分集合であるが、等しくはないかどうかを判断します。

関連情報として[`issubset`](@ref) (`⊆`)、[`⊈`](@ref)を参照してください。

# 例

```jldoctest
julia> (1, 2) ⊊ (1, 2, 3)
true

julia> (1, 2) ⊊ (1, 2)
false
```
