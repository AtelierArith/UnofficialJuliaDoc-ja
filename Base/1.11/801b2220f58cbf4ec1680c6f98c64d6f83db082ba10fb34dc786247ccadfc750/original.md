```
rationalize([T<:Integer=Int,] x; tol::Real=eps(x))
```

Approximate floating point number `x` as a [`Rational`](@ref) number with components of the given integer type. The result will differ from `x` by no more than `tol`.

# Examples

```jldoctest
julia> rationalize(5.6)
28//5

julia> a = rationalize(BigInt, 10.3)
103//10

julia> typeof(numerator(a))
BigInt
```
