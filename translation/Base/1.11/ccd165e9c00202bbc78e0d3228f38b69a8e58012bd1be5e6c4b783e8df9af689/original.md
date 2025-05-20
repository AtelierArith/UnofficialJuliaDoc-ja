```
<(x, y)
```

Less-than comparison operator. Falls back to [`isless`](@ref). Because of the behavior of floating-point NaN values, this operator implements a partial order.

# Implementation

New types with a canonical partial order should implement this function for two arguments of the new type. Types with a canonical total order should implement [`isless`](@ref) instead.

See also [`isunordered`](@ref).

# Examples

```jldoctest
julia> 'a' < 'b'
true

julia> "abc" < "abd"
true

julia> 5 < 3
false
```
