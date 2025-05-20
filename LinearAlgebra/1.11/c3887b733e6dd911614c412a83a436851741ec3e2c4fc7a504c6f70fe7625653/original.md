```
lu!(A, pivot = RowMaximum(); check = true, allowsingular = false) -> LU
```

`lu!` is the same as [`lu`](@ref), but saves space by overwriting the input `A`, instead of creating a copy. An [`InexactError`](@ref) exception is thrown if the factorization produces a number not representable by the element type of `A`, e.g. for integer types.

!!! compat "Julia 1.11"
    The `allowsingular` keyword argument was added in Julia 1.11.


# Examples

```jldoctest
julia> A = [4. 3.; 6. 3.]
2×2 Matrix{Float64}:
 4.0  3.0
 6.0  3.0

julia> F = lu!(A)
LU{Float64, Matrix{Float64}, Vector{Int64}}
L factor:
2×2 Matrix{Float64}:
 1.0       0.0
 0.666667  1.0
U factor:
2×2 Matrix{Float64}:
 6.0  3.0
 0.0  1.0

julia> iA = [4 3; 6 3]
2×2 Matrix{Int64}:
 4  3
 6  3

julia> lu!(iA)
ERROR: InexactError: Int64(0.6666666666666666)
Stacktrace:
[...]
```
