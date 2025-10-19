```julia
keytype(type)
```

Get the key type of a dictionary type. Behaves similarly to [`eltype`](@ref).

# Examples

```jldoctest
julia> keytype(Dict(Int32(1) => "foo"))
Int32
```
