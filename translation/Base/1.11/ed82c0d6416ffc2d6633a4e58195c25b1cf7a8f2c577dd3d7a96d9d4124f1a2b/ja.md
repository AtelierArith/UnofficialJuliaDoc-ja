```
flipsign(x, y)
```

`y`が負の場合、`x`の符号を反転させて返します。例えば `abs(x) = flipsign(x,x)`。

# 例

```jldoctest
julia> flipsign(5, 3)
5

julia> flipsign(5, -3)
-5
```
