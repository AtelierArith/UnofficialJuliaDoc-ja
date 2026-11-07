```julia
poll_fd(fd, timeout_s::Real=-1; readable=false, writable=false)
```

Monitor a file descriptor `fd` for changes in the read or write availability, and with a timeout given by `timeout_s` seconds.

The keyword arguments determine which of read and/or write status should be monitored; at least one of them must be set to `true`.

The returned value is an object with boolean fields `readable`, `writable`, and `timedout`, giving the result of the polling.

This is a thin wrapper over calling `wait` on a [`FDWatcher`](@ref), which implements the functionality but requires the user to call `close` manually when finished with it, or risk serious crashes.
