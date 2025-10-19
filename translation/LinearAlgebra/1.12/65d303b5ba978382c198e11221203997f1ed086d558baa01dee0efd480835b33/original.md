```julia
issuccess(F::LU; allowsingular = false)
```

Test that the LU factorization of a matrix succeeded. By default a factorization that produces a valid but rank-deficient U factor is considered a failure. This can be changed by passing `allowsingular = true`.

!!! compat "Julia 1.11"
    The `allowsingular` keyword argument was added in Julia 1.11.


# Examples

```jldoctest
julia> F = lu([1 2; 1 2], check = false);

julia> issuccess(F)
false

julia> issuccess(F, allowsingular = true)
true
```
