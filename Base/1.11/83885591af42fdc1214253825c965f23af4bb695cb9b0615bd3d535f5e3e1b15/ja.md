```
issubnormal(f) -> Bool
```

浮動小数点数が非正規化であるかどうかをテストします。

IEEE浮動小数点数は、指数ビットがゼロであり、有効数字がゼロでない場合に[非正規化](https://en.wikipedia.org/wiki/Subnormal_number)と呼ばれます。

# 例

```jldoctest
julia> floatmin(Float32)
1.1754944f-38

julia> issubnormal(1.0f-37)
false

julia> issubnormal(1.0f-38)
true
```
