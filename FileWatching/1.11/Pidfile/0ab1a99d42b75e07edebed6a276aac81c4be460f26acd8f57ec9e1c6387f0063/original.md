```
stale_pidfile(path::String, stale_age::Real, refresh::Real) :: Bool
```

Helper function for `open_exclusive` for deciding if a pidfile is stale.
