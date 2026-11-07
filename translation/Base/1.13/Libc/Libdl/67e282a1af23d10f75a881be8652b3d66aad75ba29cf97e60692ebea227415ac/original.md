```julia
add_dependency!(library::LazyLibrary, dependency::LazyLibrary)
```

Dynamically add a dependency that must be loaded before `library`. Only needed when dependencies cannot be determined at construction time.

!!! warning
    Dependencies added with this function are **ephemeral** and only persist within the current process. They will not persist across precompilation boundaries.


Prefer specifying dependencies in the `LazyLibrary` constructor when possible.

!!! compat "Julia 1.11"
    `add_dependency!` was added in Julia 1.11.


See also [`LazyLibrary`](@ref).
