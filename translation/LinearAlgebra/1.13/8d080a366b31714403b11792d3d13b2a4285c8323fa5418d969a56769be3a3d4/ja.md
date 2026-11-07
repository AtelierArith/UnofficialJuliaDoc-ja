```julia
fillband!(A::AbstractMatrix, x, l, u)
```

対角線 `l` と `u` の間の帯を、値 `x` で埋めます。

# Examples

```jldoctest
julia> A = zeros(4,4)
4×4 Matrix{Float64}:
 0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0

julia> LinearAlgebra.fillband!(A, 2, 0, 1)
4×4 Matrix{Float64}:
 2.0  2.0  0.0  0.0
 0.0  2.0  2.0  0.0
 0.0  0.0  2.0  2.0
 0.0  0.0  0.0  2.0
```
