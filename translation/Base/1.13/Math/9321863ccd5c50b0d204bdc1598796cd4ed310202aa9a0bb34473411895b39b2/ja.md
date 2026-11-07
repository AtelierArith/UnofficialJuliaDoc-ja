```julia
frexp(val)
```

`x` の絶対値が ``[1/2, 1)`` の範囲内または 0 であり、`val` が ``x \times 2^{exp}`` と等しくなるように、`(x,exp)` を返します。

関連項目: [`significand`](@ref)、[`exponent`](@ref)、[`ldexp`](@ref)。

# Examples

```jldoctest
julia> frexp(6.0)
(0.75, 3)

julia> significand(6.0), exponent(6.0)  # interval [1, 2) instead
(1.5, 2)

julia> frexp(0.0), frexp(NaN), frexp(-Inf)  # exponent would give an error
((0.0, 0), (NaN, 0), (-Inf, 0))
```
