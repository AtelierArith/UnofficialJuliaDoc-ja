```julia
!=(x, y)
≠(x,y)
```

Not-equals comparison operator. Always gives the opposite answer as [`==`](@ref).

# Implementation

New types should generally not implement this, and rely on the fallback definition `!=(x,y) = !(x==y)` instead.

# Examples

```jldoctest
julia> 3 != 2
true

julia> "foo" ≠ "foo"
false
```
