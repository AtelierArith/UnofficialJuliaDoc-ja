```julia
isready(rr::Future)
```

Determine whether a [`Future`](@ref) has a value stored to it.

If the argument `Future` is owned by a different node, this call will block to wait for the answer. It is recommended to wait for `rr` in a separate task instead or to use a local [`Channel`](@ref) as a proxy:

```julia
p = 1
f = Future(p)
errormonitor(@async put!(f, remotecall_fetch(long_computation, p)))
isready(f)  # will not block
```
