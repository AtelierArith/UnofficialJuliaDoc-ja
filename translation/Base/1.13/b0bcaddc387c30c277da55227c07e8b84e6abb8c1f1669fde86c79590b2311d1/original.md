```julia
isopen(s::IOStream)
```

Check if the stream is not yet closed.

A closed `IOStream` may still have data to read in its buffer, use [`eof`](@ref) to check for the ability to read data.

Use the `FileWatching` package to be notified when a file might be writable or readable.
