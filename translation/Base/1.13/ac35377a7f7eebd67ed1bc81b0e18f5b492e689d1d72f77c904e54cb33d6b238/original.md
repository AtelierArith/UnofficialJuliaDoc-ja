```julia
circshift(A, shifts)
```

Circularly shift, i.e. rotate, the data in `A`. The second argument is a tuple or vector giving the amount to shift in each dimension, or an integer to shift only in the first dimension.

The generated code is most efficient when the shift amounts are known at compile-time, i.e., compile-time constants.

See also: [`circshift!`](@ref), [`circcopy!`](@ref), [`bitrotate`](@ref), [`<<`](@ref).

# Examples

```jldoctest
julia> b = reshape(Vector(1:16), (4,4))
4×4 Matrix{Int64}:
 1  5   9  13
 2  6  10  14
 3  7  11  15
 4  8  12  16

julia> circshift(b, (0,2))
4×4 Matrix{Int64}:
  9  13  1  5
 10  14  2  6
 11  15  3  7
 12  16  4  8

julia> circshift(b, (-1,0))
4×4 Matrix{Int64}:
 2  6  10  14
 3  7  11  15
 4  8  12  16
 1  5   9  13

julia> a = BitArray([true, true, false, false, true])
5-element BitVector:
 1
 1
 0
 0
 1

julia> circshift(a, 1)
5-element BitVector:
 1
 1
 1
 0
 0

julia> circshift(a, -1)
5-element BitVector:
 1
 0
 0
 1
 1

julia> x = (1, 2, 3, 4, 5)
(1, 2, 3, 4, 5)

julia> circshift(x, 4)
(2, 3, 4, 5, 1)

julia> z = (1, 'a', -7.0, 3)
(1, 'a', -7.0, 3)

julia> circshift(z, -1)
('a', -7.0, 3, 1)
```
