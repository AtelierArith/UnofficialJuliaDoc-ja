```julia
Timer(delay; interval = 0)
```

Create a timer that wakes up tasks waiting for it (by calling [`wait`](@ref) on the timer object).

Waiting tasks are woken after an initial delay of at least `delay` seconds, and then repeating after at least `interval` seconds again elapse. If `interval` is equal to `0`, the timer is only triggered once. When the timer is closed (by [`close`](@ref)) waiting tasks are woken with an error. Use [`isopen`](@ref) to check whether a timer is still active. Use `t.timeout` and `t.interval` to read the setup conditions of a `Timer` `t`.

```julia-repl
julia> t = Timer(1.0; interval=0.5)
Timer (open, timeout: 1.0 s, interval: 0.5 s) @0x000000010f4e6e90

julia> isopen(t)
true

julia> t.timeout
1.0

julia> close(t)

julia> isopen(t)
false
```

!!! note
    `interval` is subject to accumulating time skew. If you need precise events at a particular absolute time, create a new timer at each expiration with the difference to the next time computed.


!!! note
    A `Timer` requires yield points to update its state. For instance, `isopen(t::Timer)` cannot be used to timeout a non-yielding while loop.


!!! compat "Julia 1.12     The `timeout` and `interval` readable properties were added in Julia 1.12.
