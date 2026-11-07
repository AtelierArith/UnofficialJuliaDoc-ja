```julia
ScopedThunk(f)
```

Create a callable that records the current dynamic scope, i.e. all current `ScopedValue`s, along with `f`. When the callable is invoked, it runs `f` in the recorded dynamic scope.
