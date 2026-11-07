```julia
axes(A, d)
```

Return the valid range of indices for array `A` along dimension `d`.

See also [`size`](@ref), and the manual chapter on [arrays with custom indices](@ref man-custom-indices).

# Examples

```jldoctest
julia> A = fill(1, (5,6,7));

julia> axes(A, 2)
Base.OneTo(6)

julia> axes(A, 4) == 1:1  # all dimensions d > ndims(A) have size 1
true
```

# Usage note

Each of the indices has to be an `AbstractUnitRange{<:Integer}`, but at the same time can be a type that uses custom indices. So, for example, if you need a subset, use generalized indexing constructs like `begin`/`end` or [`firstindex`](@ref)/[`lastindex`](@ref):

```julia
ix = axes(v, 1)
ix[2:end]          # will work for eg Vector, but may fail in general
ix[(begin+1):end]  # works for generalized indexes
```
