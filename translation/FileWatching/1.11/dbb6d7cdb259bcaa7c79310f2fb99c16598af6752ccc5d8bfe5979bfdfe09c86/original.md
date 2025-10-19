```julia
poll_file(path::AbstractString, interval_s::Real=5.007, timeout_s::Real=-1) -> (previous::StatStruct, current)
```

Monitor a file for changes by polling every `interval_s` seconds until a change occurs or `timeout_s` seconds have elapsed. The `interval_s` should be a long period; the default is 5.007 seconds.

Returns a pair of status objects `(previous, current)` when a change is detected. The `previous` status is always a `StatStruct`, but it may have all of the fields zeroed (indicating the file didn't previously exist, or wasn't previously accessible).

The `current` status object may be a `StatStruct`, an `EOFError` (indicating the timeout elapsed), or some other `Exception` subtype (if the `stat` operation failed: for example, if the path does not exist).

To determine when a file was modified, compare `!(current isa StatStruct && prev == current)` to detect notification of changes to the mtime or inode. However, using [`watch_file`](@ref) for this operation is preferred, since it is more reliable and efficient, although in some situations it may not be available.

This is a thin wrapper over calling `wait` on a [`PollingFileWatcher`](@ref), which implements the functionality, but this function has a small race window between consecutive calls to `poll_file` where the file might change without being detected.
