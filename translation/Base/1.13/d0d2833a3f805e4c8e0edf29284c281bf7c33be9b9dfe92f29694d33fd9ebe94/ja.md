```julia
flipsign(x, y)
```

`y` が負の場合は、`x` の符号を反転して返します。たとえば、`abs(x) = flipsign(x,x)` のようになります。

# Examples

```jldoctest
julia> flipsign(5, 3)
5

julia> flipsign(5, -3)
-5
```
