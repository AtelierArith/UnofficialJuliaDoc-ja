```julia
unsafe_textbuf(stream)
```

Return the `Vector{UInt8}` text buffer being parsed by this `ParseStream`.

!!! warning
    The caller must hold a reference to `stream` while using textbuf

