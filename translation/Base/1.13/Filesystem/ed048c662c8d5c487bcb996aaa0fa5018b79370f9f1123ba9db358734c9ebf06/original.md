```julia
symlink(target::AbstractString, link::AbstractString; dir_target = false)
```

Creates a symbolic link to `target` with the name `link`.

On Windows, symlinks must be explicitly declared as referring to a directory or not.  If `target` already exists, by default the type of `link` will be auto- detected, however if `target` does not exist, this function defaults to creating a file symlink unless `dir_target` is set to `true`.  Note that if the user sets `dir_target` but `target` exists and is a file, a directory symlink will still be created, but dereferencing the symlink will fail, just as if the user creates a file symlink (by calling `symlink()` with `dir_target` set to `false` before the directory is created) and tries to dereference it to a directory.

Additionally, there are two methods of making a link on Windows; symbolic links and junction points.  Junction points are slightly more efficient, but do not support relative paths, so if a relative directory symlink is requested (as denoted by `isabspath(target)` returning `false`) a symlink will be used, else a junction point will be used.  Best practice for creating symlinks on Windows is to create them only after the files/directories they reference are already created.

See also: [`hardlink`](@ref).

!!! note
    This function raises an error under operating systems that do not support soft symbolic links, such as Windows XP.


!!! compat "Julia 1.6"
    The `dir_target` keyword argument was added in Julia 1.6.  Prior to this, symlinks to nonexistent paths on windows would always be file symlinks, and relative symlinks to directories were not supported.

