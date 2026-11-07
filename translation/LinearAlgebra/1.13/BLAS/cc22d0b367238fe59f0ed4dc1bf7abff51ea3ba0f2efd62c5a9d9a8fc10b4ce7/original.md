```julia
axpy!(a, X, Y)
```

Overwrite `Y` with `X*a + Y`, where `a` is a scalar. Return `Y`.

# Examples

```jldoctest
julia> x = [1.; 2; 3];

julia> y = [4. ;; 5 ;; 6];

julia> BLAS.axpy!(2, x, y)
1×3 Matrix{Float64}:
 6.0  9.0  12.0
```
