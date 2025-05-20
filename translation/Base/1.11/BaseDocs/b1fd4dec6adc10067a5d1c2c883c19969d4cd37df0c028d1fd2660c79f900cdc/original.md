```
+(x, y...)
```

Addition operator.

Infix `x+y+z+...` calls this function with all arguments, i.e. `+(x, y, z, ...)`, which by default then calls `(x+y) + z + ...` starting from the left.

Note that overflow is possible for most integer types, including the default `Int`, when adding large numbers.

# Examples

```jldoctest
julia> 1 + 20 + 4
25

julia> +(1, 20, 4)
25

julia> [1,2] + [3,4]
2-element Vector{Int64}:
 4
 6

julia> typemax(Int) + 1 < 0
true
```
