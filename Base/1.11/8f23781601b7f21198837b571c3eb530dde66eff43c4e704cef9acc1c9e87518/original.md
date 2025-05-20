```
fieldnames(x::DataType)
```

Get a tuple with the names of the fields of a `DataType`.

See also [`propertynames`](@ref), [`hasfield`](@ref).

# Examples

```jldoctest
julia> fieldnames(Rational)
(:num, :den)

julia> fieldnames(typeof(1+im))
(:re, :im)
```
