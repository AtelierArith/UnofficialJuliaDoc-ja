```julia
IOContext(io::IO, context::IOContext)
```

Create an `IOContext` that wraps an alternate `IO` but inherits the properties of `context`.

!!! note
    Unless explicitly set in the wrapped `io` the `displaysize` of `io` will not be inherited. This is because by default `displaysize` is not a property of IO objects themselves, but lazily inferred, as the size of the terminal window can change during the lifetime of the IO object.

