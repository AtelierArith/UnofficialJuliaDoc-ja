```julia
axes(A)
```

配列 `A` の有効なインデックスをタプルで返します。

関連項目: [`size`](@ref)、[`keys`](@ref)、[`eachindex`](@ref)。

# Examples

```jldoctest
julia> A = fill(1, (5,6,7));

julia> axes(A)
(Base.OneTo(5), Base.OneTo(6), Base.OneTo(7))
```
