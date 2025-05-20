```
rationalize([T<:Integer=Int,] x; tol::Real=eps(x))
```

近似浮動小数点数 `x` を指定された整数型の成分を持つ [`Rational`](@ref) 数にします。結果は `x` から `tol` 以上の差はありません。

# 例

```jldoctest
julia> rationalize(5.6)
28//5

julia> a = rationalize(BigInt, 10.3)
103//10

julia> typeof(numerator(a))
BigInt
```
