```
Threads.Condition([lock])
```

A thread-safe version of [`Base.Condition`](@ref).

To call [`wait`](@ref) or [`notify`](@ref) on a `Threads.Condition`, you must first call [`lock`](@ref) on it. When `wait` is called, the lock is atomically released during blocking, and will be reacquired before `wait` returns. Therefore idiomatic use of a `Threads.Condition` `c` looks like the following:

```
lock(c)
try
    while !thing_we_are_waiting_for
        wait(c)
    end
finally
    unlock(c)
end
```

!!! compat "Julia 1.2"
    This functionality requires at least Julia 1.2.

