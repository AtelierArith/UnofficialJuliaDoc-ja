```
isbanded(A::AbstractMatrix, kl::Integer, ku::Integer) -> Bool
```

Test whether `A` is banded with lower bandwidth starting from the `kl`th superdiagonal and upper bandwidth extending through the `ku`th superdiagonal.

# Examples

```jldoctest
julia> a = [1 2; 2 -1]
2×2 Matrix{Int64}:
 1   2
 2  -1

julia> LinearAlgebra.isbanded(a, 0, 0)
false

julia> LinearAlgebra.isbanded(a, -1, 1)
true

julia> b = [1 0; -im -1] # lower bidiagonal
2×2 Matrix{Complex{Int64}}:
 1+0im   0+0im
 0-1im  -1+0im

julia> LinearAlgebra.isbanded(b, 0, 0)
false

julia> LinearAlgebra.isbanded(b, -1, 0)
true
```
