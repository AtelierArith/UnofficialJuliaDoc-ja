```julia
expm1(x)
```

Accurately compute $e^x-1$. It avoids the loss of precision involved in the direct evaluation of exp(x)-1 for small values of x.

# Examples

```jldoctest
julia> expm1(1e-16)
1.0e-16

julia> exp(1e-16) - 1
0.0
```
