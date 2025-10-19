```julia
struct
```

The most commonly used kind of type in Julia is a struct, specified as a name and a set of fields.

```julia
struct Point
    x
    y
end
```

Fields can have type restrictions, which may be parameterized:

```julia
struct Point{X}
    x::X
    y::Float64
end
```

A struct can also declare an abstract super type via `<:` syntax:

```julia
struct Point <: AbstractPoint
    x
    y
end
```

`struct`s are immutable by default; an instance of one of these types cannot be modified after construction. Use [`mutable struct`](@ref) instead to declare a type whose instances can be modified.

See the manual section on [Composite Types](@ref) for more details, such as how to define constructors.
