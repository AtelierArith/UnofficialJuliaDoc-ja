```julia
ldexp(x, n)
```

$$
x \times 2^n
$$

を計算します。

関連情報として [`frexp`](@ref), [`exponent`](@ref) を参照してください。

# 例

```jldoctest
julia> ldexp(5.0, 2)
20.0
```
