```julia
_sort!(v::AbstractVector, a::Base.Sort.Algorithm, o::Base.Order.Ordering, kw; t, offset)
```

An internal function that sorts `v` using the algorithm `a` under the ordering `o`, subject to specifications provided in `kw` (such as `lo` and `hi` in which case it only sorts `view(v, lo:hi)`)

Returns a scratch space if provided or constructed during the sort, or `nothing` if no scratch space is present.

!!! note
    `_sort!` modifies but does not return `v`.


A returned scratch space will be a `Vector{T}` where `T` is usually the eltype of `v`. There are some exceptions, for example if `eltype(v) == Union{Missing, T}` then the scratch space may be a `Vector{T}` due to `MissingOptimization` changing the eltype of `v` to `T`.

`t` is an appropriate scratch space for the algorithm at hand, to be accessed as `t[i + offset]`. `t` is used for an algorithm to pass a scratch space back to itself in internal or recursive calls.
