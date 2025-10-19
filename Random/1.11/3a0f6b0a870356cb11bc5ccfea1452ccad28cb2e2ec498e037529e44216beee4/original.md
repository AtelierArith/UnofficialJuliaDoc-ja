```julia
randcycle([rng=default_rng(),] n::Integer)
```

Construct a random cyclic permutation of length `n`. The optional `rng` argument specifies a random number generator, see [Random Numbers](@ref). The element type of the result is the same as the type of `n`.

Here, a "cyclic permutation" means that all of the elements lie within a single cycle.  If `n > 0`, there are $(n-1)!$ possible cyclic permutations, which are sampled uniformly.  If `n == 0`, `randcycle` returns an empty vector.

[`randcycle!`](@ref) is an in-place variant of this function.

!!! compat "Julia 1.1"
    In Julia 1.1 and above, `randcycle` returns a vector `v` with `eltype(v) == typeof(n)` while in Julia 1.0 `eltype(v) == Int`.


# Examples

```jldoctest
julia> randcycle(Xoshiro(123), 6)
6-element Vector{Int64}:
 5
 4
 2
 6
 3
 1
```
