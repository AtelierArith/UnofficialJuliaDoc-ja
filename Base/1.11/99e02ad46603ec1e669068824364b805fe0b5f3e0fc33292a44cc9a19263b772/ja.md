```
issetequal(a, b) -> Bool
```

`a` と `b` が同じ要素を持っているかどうかを判断します。`a ⊆ b && b ⊆ a` と同等ですが、可能な場合はより効率的です。

関連項目: [`isdisjoint`](@ref), [`union`](@ref).

# 例

```jldoctest
julia> issetequal([1, 2], [1, 2, 3])
false

julia> issetequal([1, 2], [2, 1])
true
```
