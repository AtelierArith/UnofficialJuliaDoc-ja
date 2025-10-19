```julia
any!(r, A)
```

Test whether any values in `A` along the singleton dimensions of `r` are `true`, and write results to `r`.

!!! warning
    Behavior can be unexpected when any mutated argument shares memory with any other argument.


# Examples

```jldoctest
julia> A = [true false; true false]
2×2 Matrix{Bool}:
 1  0
 1  0

julia> any!([1; 1], A)
2-element Vector{Int64}:
 1
 1

julia> any!([1 1], A)
1×2 Matrix{Int64}:
 1  0
```
