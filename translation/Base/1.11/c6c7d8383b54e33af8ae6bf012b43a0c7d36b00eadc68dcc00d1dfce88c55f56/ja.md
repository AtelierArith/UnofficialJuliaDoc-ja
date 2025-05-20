```
⊊(a, b) -> Bool
⊋(b, a) -> Bool
```

`a`が`b`の部分集合であるが、等しくないかどうかを判断します。

関連情報としては、[`issubset`](@ref) (`⊆`)、[`⊈`](@ref)があります。

# 例

```jldoctest
julia> (1, 2) ⊊ (1, 2, 3)
true

julia> (1, 2) ⊊ (1, 2)
false
```
