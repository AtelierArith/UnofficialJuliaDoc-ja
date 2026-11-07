```julia
randsubseq!([rng=default_rng(),] S, A, p)
```

Like [`randsubseq`](@ref), but the results are stored in `S` (which is resized as needed).

# Examples

```jldoctest
julia> S = Int64[];

julia> randsubseq!(Xoshiro(123), S, 1:8, 0.3)
2-element Vector{Int64}:
 4
 7

julia> S
2-element Vector{Int64}:
 4
 7
```
