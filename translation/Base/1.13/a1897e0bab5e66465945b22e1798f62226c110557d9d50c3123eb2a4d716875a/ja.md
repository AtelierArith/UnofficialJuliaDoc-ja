```julia
fieldname(x::DataType, i::Integer)
```

`DataType` のフィールド `i` の名前を取得します。

戻り値の型は `Symbol` です。ただし、`x <: Tuple` の場合は、フィールドのインデックスが返され、その型は `Int` です。

# Examples

```jldoctest
julia> fieldname(Rational, 1)
:num

julia> fieldname(Rational, 2)
:den

julia> fieldname(Tuple{String,Int}, 2)
2
```
