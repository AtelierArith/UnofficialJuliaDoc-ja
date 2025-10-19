```julia
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

A `try/catch` block can also have an `else` clause that executes only if no exception occurred:

```julia
try
    a_dangerous_operation()
catch
    @warn "The operation failed."
else
    @info "The operation succeeded."
end
```

A `try` or `try`/`catch` block can also have a [`finally`](@ref) clause that executes at the end, regardless of whether an exception occurred.  For example, this can be used to guarantee that an opened file is closed:

```julia
f = open("file")
try
    operate_on_file(f)
catch
    @warn "An error occurred!"
finally
    close(f)
end
```

(`finally` can also be used without a `catch` block.)

!!! compat "Julia 1.8"
    Else clauses require at least Julia 1.8.

