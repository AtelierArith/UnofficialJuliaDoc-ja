```julia
exp2(x)
```

Compute the base 2 exponential of `x`, in other words $2^x$.

See also [`ldexp`](@ref), [`<<`](@ref).

# Examples

```jldoctest
julia> exp2(5)
32.0

julia> 2^5
32

julia> exp2(63) > typemax(Int)
true
```
