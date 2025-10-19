```julia
FieldError(type::DataType, field::Symbol)
```

An operation tried to access invalid `field` on an object of `type`.

!!! compat "Julia 1.12"
    Prior to Julia 1.12, invalid field access threw an [`ErrorException`](@ref)


See [`getfield`](@ref)

# Examples

```jldoctest
julia> struct AB
          a::Float32
          b::Float64
       end

julia> ab = AB(1, 3)
AB(1.0f0, 3.0)

julia> ab.c # field `c` doesn't exist
ERROR: FieldError: type AB has no field `c`, available fields: `a`, `b`
Stacktrace:
[...]
```
