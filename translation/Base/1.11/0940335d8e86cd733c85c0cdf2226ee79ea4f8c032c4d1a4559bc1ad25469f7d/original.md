```
readavailable(stream)
```

Read available buffered data from a stream. Actual I/O is performed only if no data has already been buffered. The result is a `Vector{UInt8}`.

!!! warning
    The amount of data returned is implementation-dependent; for example it can depend on the internal choice of buffer size. Other functions such as [`read`](@ref) should generally be used instead.

