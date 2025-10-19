```julia
stale_pidfile(path::String, stale_age::Real, refresh::Real) :: Bool
```

`open_exclusive` のためのヘルパー関数で、pidfile が古いかどうかを判断します。
