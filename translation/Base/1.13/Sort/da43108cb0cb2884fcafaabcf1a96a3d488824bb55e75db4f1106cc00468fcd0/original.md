```julia
sort(v; alg::Base.Sort.Algorithm=Base.Sort.defalg(v), lt=isless, by=identity, rev::Bool=false, order::Base.Order.Ordering=Base.Order.Forward)
sort(v::NTuple; kws...)::NTuple
```

Variant of [`sort!`](@ref) that returns a sorted copy of `v` leaving `v` itself unmodified.

When calling `sort` on the [`keys`](@ref) or [`values`](@ref) of a dictionary, `v` is collected and then sorted.

!!! compat "Julia 1.12"
    Sorting `NTuple`s requires Julia 1.12 or later.


!!! compat "Julia 1.13"
    Sorting keys sets and values iterators requires Julia 1.13 or later.


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

julia> sort(values(Dict('a'=>2, 'b'=>1)))
2-element Vector{Int64}:
 1
 2
```
