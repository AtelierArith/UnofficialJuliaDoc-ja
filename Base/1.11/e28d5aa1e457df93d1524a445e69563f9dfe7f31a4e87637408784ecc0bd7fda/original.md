```
invpermute!(v, p)
```

Like [`permute!`](@ref), but the inverse of the given permutation is applied.

Note that if you have a pre-allocated output array (e.g. `u = similar(v)`), it is quicker to instead employ `u[p] = v`.  (`invpermute!` internally allocates a copy of the data.)

!!! warning
    Behavior can be unexpected when any mutated argument shares memory with any other argument.


# Examples

```jldoctest
julia> A = [1, 1, 3, 4];

julia> perm = [2, 4, 3, 1];

julia> invpermute!(A, perm);

julia> A
4-element Vector{Int64}:
 4
 1
 3
 1
```
