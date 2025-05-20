```
put!(rr::RemoteChannel, args...)
```

Store a set of values to the [`RemoteChannel`](@ref). If the channel is full, blocks until space is available. Return the first argument.
