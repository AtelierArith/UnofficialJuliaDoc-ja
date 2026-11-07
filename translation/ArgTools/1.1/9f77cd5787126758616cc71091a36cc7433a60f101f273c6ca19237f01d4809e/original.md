```julia
ArgRead = Union{AbstractString, AbstractCmd, IO}
```

The `ArgRead` types is a union of the types that the `arg_read` function knows how to convert into readable IO handles. See [`arg_read`](@ref) for details.
