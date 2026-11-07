```julia
rationalize([T<:Integer=Int,] x; tol::Real=eps(x))
```

浮動小数点数 `x` を、指定された整数型の成分を持つ [`Rational`](@ref) 数として近似します。結果と `x` との差は、`tol` 以下です。

# Examples

```jldoctest
julia> rationalize(5.6)
28//5

julia> a = rationalize(BigInt, 10.3)
103//10

julia> typeof(numerator(a))
BigInt
```
