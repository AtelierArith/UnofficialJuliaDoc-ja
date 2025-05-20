```
nfields(x) -> Int
```

Get the number of fields in the given object.

# Examples

```jldoctest
julia> a = 1//2;

julia> nfields(a)
2

julia> b = 1
1

julia> nfields(b)
0

julia> ex = ErrorException("I've done a bad thing");

julia> nfields(ex)
1
```

In these examples, `a` is a [`Rational`](@ref), which has two fields. `b` is an `Int`, which is a primitive bitstype with no fields at all. `ex` is an [`ErrorException`](@ref), which has one field.
