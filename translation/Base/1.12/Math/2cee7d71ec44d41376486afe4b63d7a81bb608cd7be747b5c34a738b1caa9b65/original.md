```julia
sqrt(x)
```

Return $\sqrt{x}$.

Throw a [`DomainError`](@ref) for negative [`Real`](@ref) arguments. Use [`Complex`](@ref) negative arguments instead to obtain a [`Complex`](@ref) result.

The prefix operator `√` is equivalent to `sqrt`.

!!! note "Branch cut"
    `sqrt` has a branch cut along the negative real axis; `-0.0im` is taken to be below the axis.


See also: [`hypot`](@ref).

# Examples

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> sqrt(big(81))
9.0

julia> sqrt(big(-81))
ERROR: DomainError with -81.0:
NaN result for non-NaN input.
Stacktrace:
 [1] sqrt(::BigFloat) at ./mpfr.jl:501
[...]

julia> sqrt(big(complex(-81)))
0.0 + 9.0im

julia> sqrt(-81 - 0.0im)  # -0.0im is below the branch cut
0.0 - 9.0im

julia> .√(1:4)
4-element Vector{Float64}:
 1.0
 1.4142135623730951
 1.7320508075688772
 2.0
```
