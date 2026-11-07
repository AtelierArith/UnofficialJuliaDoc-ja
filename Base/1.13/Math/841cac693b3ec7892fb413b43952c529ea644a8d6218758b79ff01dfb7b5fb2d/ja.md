```julia
ldexp(x, n)
```

``x \times 2^n`` を計算します。

[`frexp`](@ref)、[`exponent`](@ref) も参照してください。

# Examples

```jldoctest
julia> ldexp(5.0, 2)
20.0
```
