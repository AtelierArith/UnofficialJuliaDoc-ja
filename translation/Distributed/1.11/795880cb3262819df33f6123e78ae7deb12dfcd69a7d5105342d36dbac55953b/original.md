```julia
fetch(x::Future)
```

Wait for and get the value of a [`Future`](@ref). The fetched value is cached locally. Further calls to `fetch` on the same reference return the cached value. If the remote value is an exception, throws a [`RemoteException`](@ref) which captures the remote exception and backtrace.
