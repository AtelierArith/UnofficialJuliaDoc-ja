```julia
isready(rr::RemoteChannel, args...)
```

Determine whether a [`RemoteChannel`](@ref) has a value stored to it. Note that this function can cause race conditions, since by the time you receive its result it may no longer be true. However, it can be safely used on a [`Future`](@ref) since they are assigned only once.
