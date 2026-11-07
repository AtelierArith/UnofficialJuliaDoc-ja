```julia
Base.@acquire s::Semaphore expr
```

Macro version of `Base.acquire(f, s::Semaphore)` but with `expr` instead of `f` function. Expands to:

```julia
Base.acquire(s)
try
    expr
finally
    Base.release(s)
end
```

This is similar to using [`acquire`](@ref) with a `do` block, but avoids creating a closure.

!!! compat "Julia 1.13"
    `Base.@acquire` was added in Julia 1.13

