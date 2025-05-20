```
ScopedValue(x)
```

Create a container that propagates values across dynamic scopes. Use [`with`](@ref) to create and enter a new dynamic scope.

Values can only be set when entering a new dynamic scope, and the value referred to will be constant during the execution of a dynamic scope.

Dynamic scopes are propagated across tasks.

# Examples

```jldoctest
julia> using Base.ScopedValues;

julia> const sval = ScopedValue(1);

julia> sval[]
1

julia> with(sval => 2) do
           sval[]
       end
2

julia> sval[]
1
```

!!! compat "Julia 1.11"
    Scoped values were introduced in Julia 1.11. In Julia 1.8+ a compatible implementation is available from the package ScopedValues.jl.

