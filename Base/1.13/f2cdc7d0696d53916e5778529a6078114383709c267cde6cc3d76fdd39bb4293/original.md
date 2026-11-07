```julia
cumprod(itr)
```

Cumulative product of an iterator.

See also [`cumprod!`](@ref), [`accumulate`](@ref), [`cumsum`](@ref).

!!! compat "Julia 1.5"
    `cumprod` on a non-array iterator requires at least Julia 1.5.


# Examples

```jldoctest
julia> cumprod(fill(1//2, 3))
3-element Vector{Rational{Int64}}:
 1//2
 1//4
 1//8

julia> cumprod((1, 2, 1, 3, 1))
(1, 2, 2, 6, 6)

julia> cumprod("julia")
5-element Vector{String}:
 "j"
 "ju"
 "jul"
 "juli"
 "julia"
```
