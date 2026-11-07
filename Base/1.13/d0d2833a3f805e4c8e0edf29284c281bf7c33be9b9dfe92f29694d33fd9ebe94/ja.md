```julia
flipsign(x, y)
```

`y` が負の場合は、`x` の符号を反転してください。たとえば、`abs(x) = flipsign(x,x)` です。

# Examples

```jldoctest
julia> flipsign(5, 3)
5

julia> flipsign(5, -3)
-5
```
