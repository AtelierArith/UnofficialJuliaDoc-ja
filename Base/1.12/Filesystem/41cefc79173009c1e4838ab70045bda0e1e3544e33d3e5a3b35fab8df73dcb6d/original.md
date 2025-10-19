```julia
Base.rename(oldpath::AbstractString, newpath::AbstractString)
```

Change the name of a file or directory from `oldpath` to `newpath`. If `newpath` is an existing file or empty directory it may be replaced. Equivalent to [rename(2)](https://man7.org/linux/man-pages/man2/rename.2.html) on Unix. If a path contains a "\0" throw an `ArgumentError`. On other failures throw an `IOError`. Return `newpath`.

This is a lower level filesystem operation used to implement [`mv`](@ref).

OS-specific restrictions may apply when `oldpath` and `newpath` are in different directories.

Currently there are a few differences in behavior on Windows which may be resolved in a future release. Specifically, currently on Windows:

1. `rename` will fail if `oldpath` or `newpath` are opened files.
2. `rename` will fail if `newpath` is an existing directory.
3. `rename` may work if `newpath` is a file and `oldpath` is a directory.
4. `rename` may remove `oldpath` if it is a hardlink to `newpath`.

See also: [`mv`](@ref).

!!! compat "Julia 1.12"
    This method was made public in Julia 1.12.

