```
modf(x)
```

数の小数部分と整数部分のタプル `(fpart, ipart)` を返します。両方の部分は引数と同じ符号を持ちます。

# 例

```jldoctest
julia> modf(3.5)
(0.5, 3.0)

julia> modf(-3.5)
(-0.5, -3.0)
```
