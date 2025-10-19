```julia
frexp(val)
```

戻り値は `(x,exp)` であり、`x` は区間 $[1/2, 1)$ または 0 の大きさを持ち、`val` は $x \times 2^{exp}$ に等しいです。

関連情報として [`significand`](@ref), [`exponent`](@ref), [`ldexp`](@ref) を参照してください。

# 例

```jldoctest
julia> frexp(6.0)
(0.75, 3)

julia> significand(6.0), exponent(6.0)  # 区間 [1, 2) の代わり
(1.5, 2)

julia> frexp(0.0), frexp(NaN), frexp(-Inf)  # 指数はエラーを引き起こす
((0.0, 0), (NaN, 0), (-Inf, 0))
```
