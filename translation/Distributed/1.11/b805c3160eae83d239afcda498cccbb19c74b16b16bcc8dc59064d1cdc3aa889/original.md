```julia
capture_exception(ex::RemoteException, bt)
```

Returns `ex::RemoteException` which has already captured a backtrace (via it's [`CapturedException`](@ref) field `captured`).
