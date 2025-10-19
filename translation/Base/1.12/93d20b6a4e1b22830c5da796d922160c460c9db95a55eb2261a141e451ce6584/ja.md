```julia
isdisjoint(a, b) -> Bool
```

コレクション `a` と `b` が互いに素であるかどうかを判断します。`isempty(a ∩ b)` と同等ですが、可能な場合はより効率的です。

関連: [`intersect`](@ref), [`isempty`](@ref), [`issetequal`](@ref).

!!! compat "Julia 1.5"
    この関数は少なくとも Julia 1.5 が必要です。


# 例

```jldoctest
julia> isdisjoint([1, 2], [2, 3, 4])
false

julia> isdisjoint([3, 1], [2, 4])
true
```
