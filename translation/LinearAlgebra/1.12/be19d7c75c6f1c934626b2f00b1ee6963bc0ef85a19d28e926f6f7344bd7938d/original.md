```julia
mul!(Y, A, B) -> Y
```

Calculates the matrix-matrix or matrix-vector product $A B$ and stores the result in `Y`, overwriting the existing value of `Y`. Note that `Y` must not be aliased with either `A` or `B`.

# Examples

```jldoctest
julia> A = [1.0 2.0; 3.0 4.0]; B = [1.0 1.0; 1.0 1.0]; Y = similar(B);

julia> mul!(Y, A, B) === Y
true

julia> Y
2×2 Matrix{Float64}:
 3.0  3.0
 7.0  7.0

julia> Y == A * B
true
```

# Implementation

For custom matrix and vector types, it is recommended to implement 5-argument `mul!` rather than implementing 3-argument `mul!` directly if possible.
