```julia
strides(A)
```

各次元のメモリストライドをタプルで返します。

関連項目: [`stride`](@ref)。

# Examples

```jldoctest
julia> A = fill(1, (3,4,5));

julia> strides(A)
(1, 3, 12)
```
