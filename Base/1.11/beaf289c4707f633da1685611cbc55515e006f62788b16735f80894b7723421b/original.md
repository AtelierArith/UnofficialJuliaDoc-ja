```
imag(A::AbstractArray)
```

Return an array containing the imaginary part of each entry in array `A`.

Equivalent to `imag.(A)`, except that when `A` has zero dimensions, a 0-dimensional array is returned (rather than a scalar).

# Examples

```jldoctest
julia> imag([1, 2im, 3 + 4im])
3-element Vector{Int64}:
 0
 2
 4

julia> imag(fill(2 - im))
0-dimensional Array{Int64, 0}:
-1
```
