```
fieldname(x::DataType, i::Integer)
```

Get the name of field `i` of a `DataType`.

# Examples

```jldoctest
julia> fieldname(Rational, 1)
:num

julia> fieldname(Rational, 2)
:den
```
