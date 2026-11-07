```julia
public
```

`public` is used within modules to tell Julia which names are part of the public API of the module. For example: `public foo` indicates that the name `foo` is public, without making it available when [`using`](@ref) the module.

As [`export`](@ref) already indicates that a name is public, it is unnecessary and an error to declare a name both as `public` and as `export`ed. See the [manual section about modules](@ref modules) for details.

!!! compat "Julia 1.11"
    The public keyword was added in Julia 1.11. Prior to this the notion of publicness was less explicit.

