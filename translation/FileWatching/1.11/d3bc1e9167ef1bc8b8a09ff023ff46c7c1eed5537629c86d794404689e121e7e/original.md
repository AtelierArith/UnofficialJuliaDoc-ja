```julia
PollingFileWatcher(path::AbstractString, interval_s::Real=5.007)
```

Monitor a file for changes by polling `stat` every `interval_s` seconds until a change occurs or `timeout_s` seconds have elapsed. The `interval_s` should be a long period; the default is 5.007 seconds. Call `stat` on it to get the most recent, but old, result.

This acts like an auto-reset Event, so calling `wait` blocks until the `stat` result has changed since the previous value captured upon entry to the `wait` call. The `wait` function will return a pair of status objects `(previous, current)` once any `stat` change is detected since the previous time that `wait` was called. The `previous` status is always a `StatStruct`, but it may have all of the fields zeroed (indicating the file didn't previously exist, or wasn't previously accessible).

The `current` status object may be a `StatStruct`, an `EOFError` (if the wait is canceled by closing this object), or some other `Exception` subtype (if the `stat` operation failed: for example, if the path is removed). Note that `stat` value may be outdated if the file has changed again multiple times.

Using [`FileMonitor`](@ref) for this operation is preferred, since it is more reliable and efficient, although in some situations it may not be available.
