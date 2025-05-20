```
exponent(x::Real) -> Int
```

`2^y ≤ abs(x)` を満たす最大の整数 `y` を返します。

`x` がゼロ、無限大、または [`NaN`](@ref) の場合、`DomainError` をスローします。他の非非正規化浮動小数点数 `x` に対しては、これは `x` の指数ビットに対応します。

他に [`signbit`](@ref)、[`significand`](@ref)、[`frexp`](@ref)、[`issubnormal`](@ref)、[`log2`](@ref)、[`ldexp`](@ref) も参照してください。

# 例

```jldoctest
julia> exponent(8)
3

julia> exponent(6.5)
2

julia> exponent(-1//4)
-2

julia> exponent(3.142e-4)
-12

julia> exponent(floatmin(Float32)), exponent(nextfloat(0.0f0))
(-126, -149)

julia> exponent(0.0)
ERROR: DomainError with 0.0:
Cannot be ±0.0.
[...]
```
