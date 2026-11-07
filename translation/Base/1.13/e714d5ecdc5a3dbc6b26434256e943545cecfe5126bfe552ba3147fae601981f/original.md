```julia
Base.Splat{F} <: Function
```

Represents a splatted function. That is

```julia
Base.Splat(f)(args) === f(args...)
```

The preferred way to construct an instance of `Base.Splat` is to use the [`splat`](@ref) function.

!!! compat "Julia 1.9"
    Splat requires at least Julia 1.9. In earlier versions `splat` returns an anonymous function instead.


See also [`splat`](@ref).
