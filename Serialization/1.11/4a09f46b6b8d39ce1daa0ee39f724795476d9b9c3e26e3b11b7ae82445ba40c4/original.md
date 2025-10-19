```julia
deserialize(stream)
```

Read a value written by [`serialize`](@ref). `deserialize` assumes the binary data read from `stream` is correct and has been serialized by a compatible implementation of [`serialize`](@ref). `deserialize` is designed for simplicity and performance, and so does not validate the data read. Malformed data can result in process termination. The caller must ensure the integrity and correctness of data read from `stream`.
