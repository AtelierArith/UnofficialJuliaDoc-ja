```julia
stale_pidfile(path::String, stale_age::Real, refresh::Real) :: Bool
```

pidfile が古いかどうかを判定する `open_exclusive` 用のヘルパー関数。
