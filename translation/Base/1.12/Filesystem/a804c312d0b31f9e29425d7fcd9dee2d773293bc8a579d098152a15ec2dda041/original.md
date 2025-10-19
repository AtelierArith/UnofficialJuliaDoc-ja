```julia
mkpath(path::AbstractString; mode::Unsigned = 0o777)
```

Create all intermediate directories in the `path` as required. Directories are created with the permissions `mode` which defaults to `0o777` and is modified by the current file creation mask. Unlike [`mkdir`](@ref), `mkpath` does not error if `path` (or parts of it) already exists. However, an error will be thrown if `path` (or parts of it) points to an existing file. Return `path`.

If `path` includes a filename you will probably want to use `mkpath(dirname(path))` to avoid creating a directory using the filename.

# Examples

```julia-repl
julia> cd(mktempdir())

julia> mkpath("my/test/dir") # creates three directories
"my/test/dir"

julia> readdir()
1-element Vector{String}:
 "my"

julia> cd("my")

julia> readdir()
1-element Vector{String}:
 "test"

julia> readdir("test")
1-element Vector{String}:
 "dir"

julia> mkpath("intermediate_dir/actually_a_directory.txt") # creates two directories
"intermediate_dir/actually_a_directory.txt"

julia> isdir("intermediate_dir/actually_a_directory.txt")
true

julia> mkpath("my/test/dir/") # returns the original `path`
"my/test/dir/"
```
