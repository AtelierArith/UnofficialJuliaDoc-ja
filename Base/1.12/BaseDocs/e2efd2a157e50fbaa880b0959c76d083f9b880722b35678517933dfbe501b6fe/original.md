```julia
-(x)
```

Unary minus operator.

See also: [`abs`](@ref), [`flipsign`](@ref).

# Examples

```jldoctest
julia> -1
-1

julia> -(2)
-2

julia> -[1 2; 3 4]
2×2 Matrix{Int64}:
 -1  -2
 -3  -4

julia> -(true)  # promotes to Int
-1

julia> -(0x003)
0xfffd
```
