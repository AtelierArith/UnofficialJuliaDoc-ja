```
try/catch
```

A `try`/`catch` statement allows intercepting errors (exceptions) thrown by [`throw`](@ref) so that program execution can continue. For example, the following code attempts to write a file, but warns the user and proceeds instead of terminating execution if the file cannot be written:

```julia
try
    open("/danger", "w") do f
        println(f, "Hello")
    end
catch
    @warn "Could not write file."
end
```

or, when the file cannot be read into a variable:

```julia
lines = try
    open("/danger", "r") do f
        readlines(f)
    end
catch
    @warn "File not found."
end
```

The syntax `catch e` (where `e` is any variable) assigns the thrown exception object to the given variable within the `catch` block.

The power of the `try`/`catch` construct lies in the ability to unwind a deeply nested computation immediately to a much higher level in the stack of calling functions.
