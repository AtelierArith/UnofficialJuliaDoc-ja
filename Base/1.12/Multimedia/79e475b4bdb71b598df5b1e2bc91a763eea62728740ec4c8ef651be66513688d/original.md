```julia
@MIME_str
```

A convenience macro for writing [`MIME`](@ref) types, typically used when adding methods to [`show`](@ref). For example the syntax `show(io::IO, ::MIME"text/html", x::MyType) = ...` could be used to define how to write an HTML representation of `MyType`.
