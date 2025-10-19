```julia
@v_str
```

String macro used to parse a string to a [`VersionNumber`](@ref).

# Examples

```jldoctest
julia> v"1.2.3"
v"1.2.3"

julia> v"2.0.1-rc1"
v"2.0.1-rc1"
```
