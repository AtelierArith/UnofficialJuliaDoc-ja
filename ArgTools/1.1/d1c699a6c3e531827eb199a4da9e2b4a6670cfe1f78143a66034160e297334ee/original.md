```julia
ArgWrite = Union{AbstractString, AbstractCmd, IO}
```

The `ArgWrite` types is a union of the types that the `arg_write` function knows how to convert into writeable IO handles, except for `Nothing` which `arg_write` handles by generating a temporary file. See [`arg_write`](@ref) for details.
