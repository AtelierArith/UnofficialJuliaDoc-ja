```julia
Core.Type{T}
```

`Core.Type` is an abstract type which has all type objects as its instances. The only instance of the singleton type `Core.Type{T}` is the object `T`.

# Examples

```jldoctest
julia> isa(Type{Float64}, Type)
true

julia> isa(Float64, Type)
true

julia> isa(Real, Type{Float64})
false

julia> isa(Real, Type{Real})
true
```
