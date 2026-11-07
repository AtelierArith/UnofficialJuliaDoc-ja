```julia
Event([autoreset=false])
```

Create a level-triggered event source. Tasks that call [`wait`](@ref) on an `Event` are suspended and queued until [`notify`](@ref) is called on the `Event`. After `notify` is called, the `Event` remains in a signaled state and tasks will no longer block when waiting for it, until `reset` is called.

If `autoreset` is true, at most one task will be released from `wait` for each call to `notify`.

This provides an acquire & release memory ordering on notify/wait.

!!! compat "Julia 1.1"
    This functionality requires at least Julia 1.1.


!!! compat "Julia 1.8"
    The `autoreset` functionality and memory ordering guarantee requires at least Julia 1.8.

