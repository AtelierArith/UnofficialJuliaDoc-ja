```julia
reim(A::AbstractArray)
```

Return a tuple of two arrays containing respectively the real and the imaginary part of each entry in `A`.

Equivalent to `(real.(A), imag.(A))`, except that when `eltype(A) <: Real` `A` is returned without copying to represent the real part, and that when `A` has zero dimensions, a 0-dimensional array is returned (rather than a scalar).

# Examples

```jldoctest
julia> reim([1, 2im, 3 + 4im])
([1, 0, 3], [0, 2, 4])

julia> reim(fill(2 - im))
(fill(2), fill(-1))
```
