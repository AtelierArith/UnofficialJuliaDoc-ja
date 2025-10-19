```julia
mod(x::Integer, r::AbstractUnitRange)
```

Find `y` in the range `r` such that `x` ≡ `y` (mod `n`), where `n = length(r)`, i.e. `y = mod(x - first(r), n) + first(r)`.

See also [`mod1`](@ref).

# Examples

```jldoctest
julia> mod(0, Base.OneTo(3))  # mod1(0, 3)
3

julia> mod(3, 0:2)  # mod(3, 3)
0
```

!!! compat "Julia 1.3"
    This method requires at least Julia 1.3.

