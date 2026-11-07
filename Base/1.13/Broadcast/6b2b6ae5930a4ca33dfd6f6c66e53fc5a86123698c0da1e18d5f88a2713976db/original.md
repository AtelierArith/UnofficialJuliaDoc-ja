```julia
BroadcastFunction{F} <: Function
```

Represents the "dotted" version of an operator, which broadcasts the operator over its arguments, so `BroadcastFunction(op)` is functionally equivalent to `(x...) -> (op).(x...)`.

Can be created by just passing an operator preceded by a dot to a higher-order function.

# Examples

```jldoctest
julia> a = [[1 3; 2 4], [5 7; 6 8]];

julia> b = [[9 11; 10 12], [13 15; 14 16]];

julia> map(.*, a, b)
2-element Vector{Matrix{Int64}}:
 [9 33; 20 48]
 [65 105; 84 128]

julia> Base.BroadcastFunction(+)(a, b) == a .+ b
true
```

!!! compat "Julia 1.6"
    `BroadcastFunction` and the standalone `.op` syntax are available as of Julia 1.6.

