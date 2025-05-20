```
!==(x, y)
≢(x,y)
```

Always gives the opposite answer as [`===`](@ref).

# Examples

```jldoctest
julia> a = [1, 2]; b = [1, 2];

julia> a ≢ b
true

julia> a ≢ a
false
```
