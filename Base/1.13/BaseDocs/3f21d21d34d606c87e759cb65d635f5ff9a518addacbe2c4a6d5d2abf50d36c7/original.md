```julia
Function
```

Abstract type of all functions.

# Examples

```jldoctest
julia> isa(+, Function)
true

julia> typeof(sin)
typeof(sin) (singleton type of function sin, subtype of Function)

julia> ans <: Function
true
```
