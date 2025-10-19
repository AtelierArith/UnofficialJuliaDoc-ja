```julia
randcycle!([rng=default_rng(),] A::Array{<:Integer})
```

Construct in `A` a random cyclic permutation of length `n = length(A)`. The optional `rng` argument specifies a random number generator, see [Random Numbers](@ref).

Here, a "cyclic permutation" means that all of the elements lie within a single cycle. If `A` is nonempty (`n > 0`), there are $(n-1)!$ possible cyclic permutations, which are sampled uniformly.  If `A` is empty, `randcycle!` leaves it unchanged.

[`randcycle`](@ref) is a variant of this function that allocates a new vector.

# Examples

```jldoctest
julia> randcycle!(Xoshiro(123), Vector{Int}(undef, 6))
6-element Vector{Int64}:
 5
 4
 2
 6
 3
 1
```
