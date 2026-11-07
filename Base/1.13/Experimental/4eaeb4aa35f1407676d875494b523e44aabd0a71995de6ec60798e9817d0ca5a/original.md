```julia
wait_with_timeout(c::GenericCondition; first::Bool=false, timeout::Real=0.0)
```

Wait for [`notify`](@ref) on `c` and return the `val` parameter passed to `notify`.

If the keyword `first` is set to `true`, the waiter will be put *first* in line to wake up on `notify`. Otherwise, `wait` has first-in-first-out (FIFO) behavior.

If `timeout` is specified, cancel the `wait` when it expires and return `:timed_out`. The minimum value for `timeout` is 0.001 seconds, i.e. 1 millisecond.
