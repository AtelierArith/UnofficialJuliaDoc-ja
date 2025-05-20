```
Union{Types...}
```

A `Union` type is an abstract type which includes all instances of any of its argument types. This means that `T <: Union{T,S}` and `S <: Union{T,S}`.

Like other abstract types, it cannot be instantiated, even if all of its arguments are non abstract.

# Examples

```jldoctest
julia> IntOrString = Union{Int,AbstractString}
Union{Int64, AbstractString}

julia> 1 isa IntOrString # instance of Int is included in the union
true

julia> "Hello!" isa IntOrString # String is also included
true

julia> 1.0 isa IntOrString # Float64 is not included because it is neither Int nor AbstractString
false
```

# Extended Help

Unlike most other parametric types, unions are covariant in their parameters. For example, `Union{Real, String}` is a subtype of `Union{Number, AbstractString}`.

The empty union [`Union{}`](@ref) is the bottom type of Julia.
