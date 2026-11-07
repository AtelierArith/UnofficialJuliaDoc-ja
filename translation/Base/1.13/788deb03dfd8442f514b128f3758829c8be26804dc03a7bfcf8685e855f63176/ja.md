```julia
exponent_max(T)
```

浮動小数点数型 `T` の最大値は [`exponent`](@ref) です。

# Examples

```jldoctest
julia> Base.exponent_max(Float64)
1023
```

なお、`exponent_max(T) + 1` は、バイアス付き指数フィールドの値として使用でき、`Inf` または `NaN` のセンチネル値として使われる場合があります。
