```
fieldname(x::DataType, i::Integer)
```

`DataType`のフィールド`i`の名前を取得します。

# 例

```jldoctest
julia> fieldname(Rational, 1)
:num

julia> fieldname(Rational, 2)
:den
```
