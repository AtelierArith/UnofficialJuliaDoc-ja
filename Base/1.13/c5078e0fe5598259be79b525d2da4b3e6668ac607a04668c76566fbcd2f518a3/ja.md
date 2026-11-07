```julia
invmod(n::Integer, m::Integer)
```

`n` の `m` を法とする逆元を求めます。`y` は ``n y = 1 \pmod m`` を満たし、``div(y,m) = 0`` となります。``m = 0`` の場合、または ``gcd(n,m) \neq 1`` の場合はエラーが発生します。

# Examples

```jldoctest
julia> invmod(2, 5)
3

julia> invmod(2, 3)
2

julia> invmod(5, 6)
5
```
