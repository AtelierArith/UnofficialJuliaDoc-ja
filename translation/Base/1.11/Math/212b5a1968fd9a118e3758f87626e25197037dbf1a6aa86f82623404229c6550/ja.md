```
frexp(val)
```

`x`が$[1/2, 1)$または0の範囲にあるように、`(x,exp)`を返します。そして、`val`は$x \times 2^{exp}$に等しくなります。

関連情報としては、[`significand`](@ref)、[`exponent`](@ref)、[`ldexp`](@ref)があります。

# 例

```jldoctest
julia> frexp(6.0)
(0.75, 3)

julia> significand(6.0), exponent(6.0)  # [1, 2)の範囲に代わり
(1.5, 2)

julia> frexp(0.0), frexp(NaN), frexp(-Inf)  # 指数はエラーを返します
((0.0, 0), (NaN, 0), (-Inf, 0))
```
