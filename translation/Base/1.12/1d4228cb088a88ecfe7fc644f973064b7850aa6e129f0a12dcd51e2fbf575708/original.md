```julia
@lock l expr
```

Macro version of `lock(f, l::AbstractLock)` but with `expr` instead of `f` function. Expands to:

```julia
lock(l)
try
    expr
finally
    unlock(l)
end
```

This is similar to using [`lock`](@ref) with a `do` block, but avoids creating a closure and thus can improve the performance.

!!! compat
    `@lock` was added in Julia 1.3, and exported in Julia 1.10.

