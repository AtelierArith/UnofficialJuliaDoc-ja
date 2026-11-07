```julia
exponent_max(T)
```

型が`T`である浮動小数点数の最大値[`exponent`](@ref)。

# Examples

```jldoctest
julia> Base.exponent_max(Float64)
1023
```

なお、`exponent_max(T) + 1`は、バイアス付き指数フィールドの値として使用可能であり、`Inf`または`NaN`のセンチネル値として使われる場合があります。
