```julia
@pure ex
```

`@pure` gives the compiler a hint for the definition of a pure function, helping for type inference.

!!! warning
    This macro is intended for internal compiler use and may be subject to changes.


!!! warning
    In Julia 1.8 and higher, it is favorable to use [`@assume_effects`](@ref) instead of `@pure`. This is because `@assume_effects` allows a finer grained control over Julia's purity modeling and the effect system enables a wider range of optimizations.

