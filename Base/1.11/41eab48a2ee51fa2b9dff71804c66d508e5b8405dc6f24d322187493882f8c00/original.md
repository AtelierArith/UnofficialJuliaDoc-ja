```
Timer(delay; interval = 0)
```

Create a timer that wakes up tasks waiting for it (by calling [`wait`](@ref) on the timer object).

Waiting tasks are woken after an initial delay of at least `delay` seconds, and then repeating after at least `interval` seconds again elapse. If `interval` is equal to `0`, the timer is only triggered once. When the timer is closed (by [`close`](@ref)) waiting tasks are woken with an error. Use [`isopen`](@ref) to check whether a timer is still active.

!!! note
    `interval` is subject to accumulating time skew. If you need precise events at a particular absolute time, create a new timer at each expiration with the difference to the next time computed.


!!! note
    A `Timer` requires yield points to update its state. For instance, `isopen(t::Timer)` cannot be used to timeout a non-yielding while loop.

