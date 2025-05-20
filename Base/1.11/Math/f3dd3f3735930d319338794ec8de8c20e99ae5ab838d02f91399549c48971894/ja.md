```
significand(x)
```

浮動小数点数の仮数（別名：マントissa）を抽出します。`x` がゼロでない有限数であれば、結果は `x` と同じ型および符号の数となり、その絶対値は区間 $[1,2)$ にあります。それ以外の場合は `x` が返されます。

関連情報として [`frexp`](@ref)、[`exponent`](@ref) も参照してください。

# 例

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
