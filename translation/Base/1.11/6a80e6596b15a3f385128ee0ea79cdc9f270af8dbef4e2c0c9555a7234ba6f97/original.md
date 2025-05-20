```
Condition()
```

Create an edge-triggered event source that tasks can wait for. Tasks that call [`wait`](@ref) on a `Condition` are suspended and queued. Tasks are woken up when [`notify`](@ref) is later called on the `Condition`. Waiting on a condition can return a value or raise an error if the optional arguments of [`notify`](@ref) are used. Edge triggering means that only tasks waiting at the time [`notify`](@ref) is called can be woken up. For level-triggered notifications, you must keep extra state to keep track of whether a notification has happened. The [`Channel`](@ref) and [`Threads.Event`](@ref) types do this, and can be used for level-triggered events.

This object is NOT thread-safe. See [`Threads.Condition`](@ref) for a thread-safe version.
