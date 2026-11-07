```julia
invoke_in_world(world, f, args...; kwargs...)
```

Call `f(args...; kwargs...)` in a fixed world age, `world`.

This is useful for infrastructure running in the user's Julia session which is not part of the user's program. For example, things related to the REPL, editor support libraries, etc. In these cases it can be useful to prevent unwanted method invalidation and recompilation latency, and to prevent the user from breaking supporting infrastructure by mistake.

The global world age can be queried using [`Base.get_world_counter()`](@ref) and stored for later use within the lifetime of the current Julia session, or when serializing and reloading the system image.

Technically, `invoke_in_world` will prevent any function called by `f` from being extended by the user during their Julia session. That is, generic function method tables seen by `f` (and any functions it calls) will be frozen as they existed at the given `world` age. In a sense, this is like the opposite of [`invokelatest`](@ref).

!!! note
    It is not valid to store world ages obtained in precompilation for later use. This is because precompilation generates a "parallel universe" where the world age refers to system state unrelated to the main Julia session.

