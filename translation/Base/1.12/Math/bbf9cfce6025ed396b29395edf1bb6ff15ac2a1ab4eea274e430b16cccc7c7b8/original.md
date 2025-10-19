```julia
cbrt(x::Real)
```

Return the cube root of `x`, i.e. $x^{1/3}$. Negative values are accepted (returning the negative real root when $x < 0$).

The prefix operator `∛` is equivalent to `cbrt`.

# Examples

```jldoctest
julia> cbrt(big(27))
3.0

julia> cbrt(big(-27))
-3.0
```
