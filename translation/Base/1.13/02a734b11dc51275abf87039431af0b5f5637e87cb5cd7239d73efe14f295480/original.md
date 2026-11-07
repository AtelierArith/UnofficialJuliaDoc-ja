```julia
wait(c::GenericCondition; first::Bool=false)
```

Wait for [`notify`](@ref) on `c` and return the `val` parameter passed to `notify`.

If the keyword `first` is set to `true`, the waiter will be put *first* in line to wake up on `notify`. Otherwise, `wait` has first-in-first-out (FIFO) behavior.
