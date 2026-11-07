```julia
FDWatcher(fd::Union{RawFD,WindowsRawSocket}, readable::Bool, writable::Bool)
```

Monitor a file descriptor `fd` for changes in the read or write availability.

The keyword arguments determine which of read and/or write status should be monitored; at least one of them must be set to `true`.

The returned value is an object with boolean fields `readable`, `writable`, and `timedout`, giving the result of the polling.

This acts like a level-set event, so calling `wait` blocks until one of those conditions is met, but then continues to return without blocking until the condition is cleared (either there is no more to read, or no more space in the write buffer, or both).

!!! warning
    You must call `close` manually, when finished with this object, before the fd argument is closed. Failure to do so risks serious crashes.

