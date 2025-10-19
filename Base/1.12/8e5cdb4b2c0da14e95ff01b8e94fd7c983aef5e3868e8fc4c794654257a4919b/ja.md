```julia
ndims(A::AbstractArray) -> Integer
```

`A`の次元数を返します。

関連: [`size`](@ref), [`axes`](@ref)。

# 例

```jldoctest
julia> A = fill(1, (3,4,5));

julia> ndims(A)
3
```
