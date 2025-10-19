```julia
nextprod(factors::Union{Tuple,AbstractVector}, n)
```

`n`以上の次の整数で、`factors`の因子$k_i$に対して整数$p_1$, $p_2$などを用いて$\prod k_i^{p_i}$の形で表すことができる。

# 例

```jldoctest
julia> nextprod((2, 3), 105)
108

julia> 2^2 * 3^3
108
```

!!! compat "Julia 1.6"
    タプルを受け入れるメソッドはJulia 1.6以降が必要です。

