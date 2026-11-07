```julia
significand(x)
```

浮動小数点数の仮数（マンティッサ）を取り出します。`x` がゼロ以外の有限数の場合、戻り値は `x` と同じ型および符号を持ち、絶対値が ``[1,2)`` の区間内にある数値です。それ以外の場合は `x` を返します。

[`frexp`](@ref)、[`exponent`](@ref) も参照してください。

# Examples

```jldoctest
julia> significand(15.2)
1.9

julia> significand(-15.2)
-1.9

julia> significand(-15.2) * 2^3
-15.2

julia> significand(-Inf), significand(Inf), significand(NaN)
(-Inf, Inf, NaN)
```
