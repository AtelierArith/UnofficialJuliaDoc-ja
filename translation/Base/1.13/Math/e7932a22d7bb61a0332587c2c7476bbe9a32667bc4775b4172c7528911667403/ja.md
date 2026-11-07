```julia
modf(x)
```

数値の小数部と整数部を含むタプル `(fpart, ipart)` を返します。どちらの部分も、引数と同じ符号になります。

# Examples

```jldoctest
julia> modf(3.5)
(0.5, 3.0)

julia> modf(-3.5)
(-0.5, -3.0)
```
