```julia
dlopen(f::Function, args...; kwargs...)
```

Wrapper for usage with `do` blocks to automatically close the dynamic library once control flow leaves the `do` block scope.

# Examples

```julia
vendor = dlopen("libblas") do lib
    if Libdl.dlsym(lib, :openblas_set_num_threads; throw_error=false) !== nothing
        return :openblas
    else
        return :other
    end
end
```
