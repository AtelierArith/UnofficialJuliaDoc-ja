```julia
>=(x, y)
≥(x,y)
```

Greater-than-or-equals comparison operator. Falls back to `y <= x`.

# Implementation

New types should prefer to implement [`<=`](@ref) instead of this function, and rely on the fallback definition `>=(x, y) = y <= x`.

Furthermore, in many cases it is enough to implement just [`<`](@ref) and [`==`](@ref), relying on the fallback definitions of both `<=` and `>=`.

# Examples

```jldoctest
julia> 'a' >= 'b'
false

julia> 7 ≥ 7 ≥ 3
true

julia> "abc" ≥ "abc"
true

julia> 5 >= 3
true
```
