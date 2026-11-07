```julia
ndims(A::AbstractArray)::Integer
```

`A`の次元数を返します。

関連項目: [`size`](@ref)、[`axes`](@ref)。

# Examples

```jldoctest
julia> A = fill(1, (3,4,5));

julia> ndims(A)
3
```
