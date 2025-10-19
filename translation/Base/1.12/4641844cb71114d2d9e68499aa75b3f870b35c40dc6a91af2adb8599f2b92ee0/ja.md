```julia
fieldname(x::DataType, i::Integer)
```

`DataType`のフィールド`i`の名前を取得します。

戻り値の型は`Symbol`ですが、`x <: Tuple`の場合はフィールドのインデックスが返され、その型は`Int`です。

# 例

```jldoctest
julia> fieldname(Rational, 1)
:num

julia> fieldname(Rational, 2)
:den

julia> fieldname(Tuple{String,Int}, 2)
2
```
