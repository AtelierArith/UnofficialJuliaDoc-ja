```julia
AbstractScopedValue{T}
```

Abstract base type for scoped values that propagate values across dynamic scopes. All scoped value types must extend this abstract type.

See also: [`ScopedValue`](@ref), [`LazyScopedValue`](@ref)

!!! compat "Julia 1.13"
    AbstractScopedValue requires Julia 1.13+.

