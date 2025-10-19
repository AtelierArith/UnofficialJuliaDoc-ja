```julia
invmod(n::Integer, m::Integer)
```

Take the inverse of `n` modulo `m`: `y` such that $n y = 1 \pmod m$, and $div(y,m) = 0$. This will throw an error if $m = 0$, or if $gcd(n,m) \neq 1$.

# Examples

```jldoctest
julia> invmod(2, 5)
3

julia> invmod(2, 3)
2

julia> invmod(5, 6)
5
```
