```julia
isdisjoint(a, b)::Bool
```

コレクション `a` と `b` が互いに素かどうかを判定します。`isempty(a ∩ b)` と同等ですが、可能な場合はこちらのほうが効率的です。

関連項目: [`intersect`](@ref)、[`isempty`](@ref)、[`issetequal`](@ref)。

!!! compat "Julia 1.5"
    この関数を使用するには、Julia 1.5 以降が必要です。


# Examples

```jldoctest
julia> isdisjoint([1, 2], [2, 3, 4])
false

julia> isdisjoint([3, 1], [2, 4])
true
```
