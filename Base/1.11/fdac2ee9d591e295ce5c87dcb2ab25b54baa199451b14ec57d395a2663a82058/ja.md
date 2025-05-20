```
invmod(n::Integer, m::Integer)
```

`m`を法とした`n`の逆元を取ります：$n y = 1 \pmod m$となる`y`で、$div(y,m) = 0$です。`m = 0`の場合、または$gcd(n,m) \neq 1$の場合はエラーが発生します。

# 例

```jldoctest
julia> invmod(2, 5)
3

julia> invmod(2, 3)
2

julia> invmod(5, 6)
5
```
