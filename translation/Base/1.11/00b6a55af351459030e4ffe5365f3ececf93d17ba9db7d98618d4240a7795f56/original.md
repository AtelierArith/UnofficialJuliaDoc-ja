```
Base.issingletontype(T)
```

Determine whether type `T` has exactly one possible instance; for example, a struct type with no fields except other singleton values. If `T` is not a concrete type, then return `false`.
