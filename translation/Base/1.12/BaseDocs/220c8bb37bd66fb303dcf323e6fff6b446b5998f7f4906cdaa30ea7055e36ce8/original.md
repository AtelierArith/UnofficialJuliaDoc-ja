```julia
mutable struct
```

`mutable struct` is similar to [`struct`](@ref), but additionally allows the fields of the type to be set after construction.

Individual fields of a mutable struct can be marked as `const` to make them immutable:

```julia
mutable struct Baz
    a::Int
    const b::Float64
end
```

!!! compat "Julia 1.8"
    The `const` keyword for fields of mutable structs requires at least Julia 1.8.


See the manual section on [Composite Types](@ref) for more information.
