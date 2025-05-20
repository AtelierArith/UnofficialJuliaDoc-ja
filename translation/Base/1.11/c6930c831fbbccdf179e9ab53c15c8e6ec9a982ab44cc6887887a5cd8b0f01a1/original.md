```
nextprod(factors::Union{Tuple,AbstractVector}, n)
```

Next integer greater than or equal to `n` that can be written as $\prod k_i^{p_i}$ for integers $p_1$, $p_2$, etcetera, for factors $k_i$ in `factors`.

# Examples

```jldoctest
julia> nextprod((2, 3), 105)
108

julia> 2^2 * 3^3
108
```

!!! compat "Julia 1.6"
    The method that accepts a tuple requires Julia 1.6 or later.

