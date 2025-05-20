```
mul!(C, A, B, α, β) -> C
```

Combined inplace matrix-matrix or matrix-vector multiply-add $A B α + C β$. The result is stored in `C` by overwriting it.  Note that `C` must not be aliased with either `A` or `B`.

!!! compat "Julia 1.3"
    Five-argument `mul!` requires at least Julia 1.3.


# Examples

```jldoctest
julia> A = [1.0 2.0; 3.0 4.0]; B = [1.0 1.0; 1.0 1.0]; C = [1.0 2.0; 3.0 4.0];

julia> α, β = 100.0, 10.0;

julia> mul!(C, A, B, α, β) === C
true

julia> C
2×2 Matrix{Float64}:
 310.0  320.0
 730.0  740.0

julia> C_original = [1.0 2.0; 3.0 4.0]; # A copy of the original value of C

julia> C == A * B * α + C_original * β
true
```
