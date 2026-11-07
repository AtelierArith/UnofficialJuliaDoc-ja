```julia
real(A::AbstractArray)
```

Return an array containing the real part of each entry in array `A`.

Equivalent to `real.(A)`, except that when `eltype(A) <: Real` `A` is returned without copying, and that when `A` has zero dimensions, a 0-dimensional array is returned (rather than a scalar).

# Examples

```jldoctest
julia> real([1, 2im, 3 + 4im])
3-element Vector{Int64}:
 1
 0
 3

julia> real(fill(2 - im))
0-dimensional Array{Int64, 0}:
2
```
