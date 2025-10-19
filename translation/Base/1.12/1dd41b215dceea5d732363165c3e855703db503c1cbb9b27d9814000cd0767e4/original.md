```julia
fieldnames(x::DataType)
```

Get a tuple with the names of the fields of a `DataType`.

Each name is a `Symbol`, except when `x <: Tuple`, in which case each name (actually the index of the field) is an `Int`.

See also [`propertynames`](@ref), [`hasfield`](@ref).

# Examples

```jldoctest
julia> fieldnames(Rational)
(:num, :den)

julia> fieldnames(typeof(1+im))
(:re, :im)

julia> fieldnames(Tuple{String,Int})
(1, 2)
```
