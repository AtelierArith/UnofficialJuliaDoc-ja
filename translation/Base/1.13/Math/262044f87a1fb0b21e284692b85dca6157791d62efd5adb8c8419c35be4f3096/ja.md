```julia
exponent(x::Real)::Int
```

`y` を返す最大の整数 `2^y ≤ abs(x)`。正規化された浮動小数点数 `x` の場合、これは `x` の指数に相当します。

`x` がゼロ、無限大、または [`NaN`](@ref) の場合、`DomainError` をスローします。その他の非サブノーマル浮動小数点数 `x` では、これは `x` の指数ビットに相当します。

!!! compat "Julia 1.14"
    `exponent` を `Bool` に対して呼び出すには、Julia 1.14 以降が必要です。


関連項目: [`signbit`](@ref)、[`significand`](@ref)、[`frexp`](@ref)、[`issubnormal`](@ref)、[`log2`](@ref)、[`ldexp`](@ref)。

# Examples

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
