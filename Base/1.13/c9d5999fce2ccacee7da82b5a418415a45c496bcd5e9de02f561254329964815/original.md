```julia
fieldindex(T, name::Symbol, err:Bool=true)
```

Get the index of a named field, throwing an error if the field does not exist (when err==true) or returning 0 (when err==false).

# Examples

```jldoctest
julia> struct Foo
           x::Int64
           y::String
       end

julia> fieldindex(Foo, :y)
2

julia> fieldindex(Foo, :z)
ERROR: FieldError: type Foo has no field `z`, available fields: `x`, `y`
Stacktrace:
[...]

julia> fieldindex(Foo, :z, false)
0
```

!!! compat "Julia 1.13"
    This function is exported as of Julia 1.13.

