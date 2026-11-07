```julia
fieldname(x::DataType, i::Integer)
```

Get the name of field `i` of a `DataType`.

The return type is `Symbol`, except when `x <: Tuple`, in which case the index of the field is returned, of type `Int`.

# Examples

```jldoctest
julia> fieldname(Rational, 1)
:num

julia> fieldname(Rational, 2)
:den

julia> fieldname(Tuple{String,Int}, 2)
2
```
