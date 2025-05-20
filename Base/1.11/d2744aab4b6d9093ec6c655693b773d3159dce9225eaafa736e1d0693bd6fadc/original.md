```
keepat!(a::Vector, inds)
keepat!(a::BitVector, inds)
```

Remove the items at all the indices which are not given by `inds`, and return the modified `a`. Items which are kept are shifted to fill the resulting gaps.

!!! warning
    Behavior can be unexpected when any mutated argument shares memory with any other argument.


`inds` must be an iterator of sorted and unique integer indices. See also [`deleteat!`](@ref).

!!! compat "Julia 1.7"
    This function is available as of Julia 1.7.


# Examples

```jldoctest
julia> keepat!([6, 5, 4, 3, 2, 1], 1:2:5)
3-element Vector{Int64}:
 6
 4
 2
```
