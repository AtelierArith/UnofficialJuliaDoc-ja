```julia
close(t::Union{Timer, AsyncCondition})
```

Close an object `t` and thus mark it as inactive. Once a timer or condition is inactive, it will not produce a new event.

See also: [`isopen`](@ref)
