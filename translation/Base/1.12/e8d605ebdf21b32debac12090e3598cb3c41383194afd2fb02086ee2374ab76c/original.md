```julia
isopen(object) -> Bool
```

Determine whether an object - such as a stream or timer – is not yet closed. Once an object is closed, it will never produce a new event. However, since a closed stream may still have data to read in its buffer, use [`eof`](@ref) to check for the ability to read data. Use the `FileWatching` package to be notified when a stream might be writable or readable.

# Examples

```jldoctest
julia> io = open("my_file.txt", "w+");

julia> isopen(io)
true

julia> close(io)

julia> isopen(io)
false
```
