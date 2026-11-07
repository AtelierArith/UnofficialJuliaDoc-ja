```julia
indentation(str::AbstractString; tabwidth=8) -> (width::Int, empty::Bool)
```

Calculate the width of leading white space. Return the width and a flag to indicate if the string is empty.

# Examples

```jldoctest
julia> Base.indentation("")
(0, true)

julia> Base.indentation("  a")
(2, false)

julia> Base.indentation("\ta"; tabwidth=3)
(3, false)
```
