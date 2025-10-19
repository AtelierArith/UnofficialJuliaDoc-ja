```julia
prevpow(a, x)
```

The largest `a^n` not greater than `x`, where `n` is a non-negative integer. `a` must be greater than 1, and `x` must not be less than 1.

See also [`nextpow`](@ref), [`isqrt`](@ref).

# Examples

```jldoctest
julia> prevpow(2, 7)
4

julia> prevpow(2, 9)
8

julia> prevpow(5, 20)
5

julia> prevpow(4, 16)
16
```
