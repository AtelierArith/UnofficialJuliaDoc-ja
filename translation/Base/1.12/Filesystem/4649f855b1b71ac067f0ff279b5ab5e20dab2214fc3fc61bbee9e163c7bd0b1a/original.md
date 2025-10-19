```julia
lstat(path)
lstat(path_elements...)
```

Like [`stat`](@ref), but for symbolic links gets the info for the link itself rather than the file it refers to.

This function must be called on a file path rather than a file object or a file descriptor.
