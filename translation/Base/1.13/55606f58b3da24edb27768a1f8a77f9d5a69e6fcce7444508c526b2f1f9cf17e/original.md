```julia
Base.isbitsunion(::Type{T})
```

Return whether a type is an "is-bits" Union type, meaning each type included in a Union is [`isbitstype`](@ref).

# Examples

```jldoctest
julia> Base.isbitsunion(Union{Float64, UInt8})
true

julia> Base.isbitsunion(Union{Float64, String})
false
```
