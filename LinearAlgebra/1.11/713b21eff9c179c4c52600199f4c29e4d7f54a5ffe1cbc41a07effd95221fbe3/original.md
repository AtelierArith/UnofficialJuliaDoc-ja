```
A / B
```

Matrix right-division: `A / B` is equivalent to `(B' \ A')'` where [`\`](@ref) is the left-division operator. For square matrices, the result `X` is such that `A == X*B`.

See also: [`rdiv!`](@ref).

# Examples

```jldoctest
julia> A = Float64[1 4 5; 3 9 2]; B = Float64[1 4 2; 3 4 2; 8 7 1];

julia> X = A / B
2×3 Matrix{Float64}:
 -0.65   3.75  -1.2
  3.25  -2.75   1.0

julia> isapprox(A, X*B)
true

julia> isapprox(X, A*pinv(B))
true
```
