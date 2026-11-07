```julia
parentindices(A)
```

Return the indices in the [`parent`](@ref) which correspond to the view `A`.

# Examples

```jldoctest
julia> A = [1 2; 3 4];

julia> V = view(A, 1, :)
2-element view(::Matrix{Int64}, 1, :) with eltype Int64:
 1
 2

julia> parentindices(V)
(1, Base.Slice(Base.OneTo(2)))
```
