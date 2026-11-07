```julia
>(x, y)
```

Greater-than comparison operator. Falls back to `y < x`.

# Implementation

Generally, new types should implement [`<`](@ref) instead of this function, and rely on the fallback definition `>(x, y) = y < x`.

# Examples

```jldoctest
julia> 'a' > 'b'
false

julia> 7 > 3 > 1
true

julia> "abc" > "abd"
false

julia> 5 > 3
true
```
