```julia
nextprod(factors::Union{Tuple,AbstractVector}, n)
```

`n`以上で、``p_1``、``p_2``などの整数について、``k_i``を`factors`で表したときに``\prod k_i^{p_i}``となる最小の整数。

# Examples

```jldoctest
julia> nextprod((2, 3), 105)
108

julia> 2^2 * 3^3
108
```

!!! compat "Julia 1.6"
    タプルを受け取るメソッドは、Julia 1.6以降で利用できます。

