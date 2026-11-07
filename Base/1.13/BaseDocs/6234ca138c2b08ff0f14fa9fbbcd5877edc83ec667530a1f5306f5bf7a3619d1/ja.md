```julia
tuple(xs...)
```

与えられたオブジェクトからタプルを構築します。

関連項目: [`Tuple`](@ref)、[`ntuple`](@ref)、[`NamedTuple`](@ref)。

# Examples

```jldoctest
julia> tuple(1, 'b', pi)
(1, 'b', π)

julia> ans === (1, 'b', π)
true

julia> Tuple(Real[1, 2, pi])  # takes a collection
(1, 2, π)
```
