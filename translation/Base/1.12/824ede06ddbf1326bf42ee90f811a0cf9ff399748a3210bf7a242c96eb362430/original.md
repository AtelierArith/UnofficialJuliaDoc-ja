```julia
read(filename::AbstractString)
```

Read the entire contents of a file as a `Vector{UInt8}`.

```julia
read(filename::AbstractString, String)
```

Read the entire contents of a file as a string.

```julia
read(filename::AbstractString, args...)
```

Open a file and read its contents. `args` is passed to `read`: this is equivalent to `open(io->read(io, args...), filename)`.
