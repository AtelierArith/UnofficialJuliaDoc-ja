```julia
callers_in_cycle(sv::AbsIntState)
```

Iterate through all callers of the given `AbsIntState` in the abstract interpretation stack (including the given `AbsIntState` itself) that are part of the same cycle, only if it is part of a cycle with multiple frames.
