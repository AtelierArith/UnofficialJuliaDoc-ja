```julia
open_exclusive(path::String; mode, poll_interval, wait, stale_age, refresh) :: File
```

Create a new a file for read-write advisory-exclusive access. If `wait` is `false` then error out if the lock files exist otherwise block until we get the lock.

For a description of the keyword arguments, see [`mkpidlock`](@ref).
