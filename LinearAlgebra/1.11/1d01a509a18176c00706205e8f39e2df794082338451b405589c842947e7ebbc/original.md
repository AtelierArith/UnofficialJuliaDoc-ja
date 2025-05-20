```
promote_leaf_eltypes(itr)
```

For an (possibly nested) iterable object `itr`, promote the types of leaf elements.  Equivalent to `promote_type(typeof(leaf1), typeof(leaf2), ...)`. Currently supports only numeric leaf elements.

# Examples

```jldoctest
julia> a = [[1,2, [3,4]], 5.0, [6im, [7.0, 8.0]]]
3-element Vector{Any}:
  Any[1, 2, [3, 4]]
 5.0
  Any[0 + 6im, [7.0, 8.0]]

julia> LinearAlgebra.promote_leaf_eltypes(a)
ComplexF64 (alias for Complex{Float64})
```
