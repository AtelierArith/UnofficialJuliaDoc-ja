```
String(v::AbstractVector{UInt8})
```

Create a new `String` object using the data buffer from byte vector `v`. If `v` is a `Vector{UInt8}` it will be truncated to zero length and future modification of `v` cannot affect the contents of the resulting string. To avoid truncation of `Vector{UInt8}` data, use `String(copy(v))`; for other `AbstractVector` types, `String(v)` already makes a copy.

When possible, the memory of `v` will be used without copying when the `String` object is created. This is guaranteed to be the case for byte vectors returned by [`take!`](@ref) on a writable [`IOBuffer`](@ref) and by calls to [`read(io, nb)`](@ref). This allows zero-copy conversion of I/O data to strings. In other cases, `Vector{UInt8}` data may be copied, but `v` is truncated anyway to guarantee consistent behavior.
