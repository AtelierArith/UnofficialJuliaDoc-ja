```julia
sort(v::Union{AbstractVector, NTuple}; alg::Base.Sort.Algorithm=Base.Sort.defalg(v), lt=isless, by=identity, rev::Bool=false, order::Base.Order.Ordering=Base.Order.Forward)
```

Variant of [`sort!`](@ref) that returns a sorted copy of `v` leaving `v` itself unmodified.

!!! compat "Julia 1.12"
    Sorting `NTuple`s requires Julia 1.12 or later.


# Examples

```jldoctest
julia> v = [3, 1, 2];

julia> sort(v)
3-element Vector{Int64}:
 1
 2
 3

julia> v
3-element Vector{Int64}:
 3
 1
 2
```
