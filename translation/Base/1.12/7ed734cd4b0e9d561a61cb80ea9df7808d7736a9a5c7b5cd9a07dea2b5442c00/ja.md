```julia
nextpow(a, x)
```

`x`以上の最小の`a^n`で、`n`は非負整数です。`a`は1より大きく、`x`は0より大きくなければなりません。

[`prevpow`](@ref)も参照してください。

# 例

```jldoctest
julia> nextpow(2, 7)
8

julia> nextpow(2, 9)
16

julia> nextpow(5, 20)
25

julia> nextpow(4, 16)
16
```
