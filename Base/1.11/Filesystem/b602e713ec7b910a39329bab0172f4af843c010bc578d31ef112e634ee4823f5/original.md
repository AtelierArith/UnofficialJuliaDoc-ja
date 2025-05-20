```
mktempdir(f::Function, parent=tempdir(); prefix="jl_")
```

Apply the function `f` to the result of [`mktempdir(parent; prefix)`](@ref) and remove the temporary directory all of its contents upon completion.

See also: [`mktemp`](@ref), [`mkdir`](@ref).

!!! compat "Julia 1.2"
    The `prefix` keyword argument was added in Julia 1.2.

