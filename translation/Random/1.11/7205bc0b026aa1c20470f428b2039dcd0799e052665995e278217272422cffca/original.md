```julia
randperm([rng=default_rng(),] n::Integer)
```

Construct a random permutation of length `n`. The optional `rng` argument specifies a random number generator (see [Random Numbers](@ref)). The element type of the result is the same as the type of `n`.

To randomly permute an arbitrary vector, see [`shuffle`](@ref) or [`shuffle!`](@ref).

!!! compat "Julia 1.1"
    In Julia 1.1 `randperm` returns a vector `v` with `eltype(v) == typeof(n)` while in Julia 1.0 `eltype(v) == Int`.


# Examples

```jldoctest
julia> randperm(Xoshiro(123), 4)
4-element Vector{Int64}:
 1
 4
 2
 3
```
