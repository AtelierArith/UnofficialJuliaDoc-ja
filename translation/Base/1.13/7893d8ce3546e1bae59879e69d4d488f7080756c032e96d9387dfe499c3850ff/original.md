```julia
valtype(type)
```

Get the value type of a dictionary type. Behaves similarly to [`eltype`](@ref).

# Examples

```jldoctest
julia> valtype(Dict(Int32(1) => "foo"))
String
```
