```julia
walkdir(dir = pwd(); topdown=true, follow_symlinks=false, onerror=throw)
```

Return an iterator that walks the directory tree of a directory.

The iterator returns a tuple containing `(path, dirs, files)`. Each iteration `path` will change to the next directory in the tree; then `dirs` and `files` will be vectors containing the directories and files in the current `path` directory. The directory tree can be traversed top-down or bottom-up. If `walkdir` or `stat` encounters a `IOError` it will rethrow the error by default. A custom error handling function can be provided through `onerror` keyword argument. `onerror` is called with a `IOError` as argument. The returned iterator is stateful so when accessed repeatedly each access will resume where the last left off, like [`Iterators.Stateful`](@ref).

See also: [`readdir`](@ref).

!!! compat "Julia 1.12"
    `pwd()` as the default directory was added in Julia 1.12.


# Examples

```julia
for (path, dirs, files) in walkdir(".")
    println("Directories in $path")
    for dir in dirs
        println(joinpath(path, dir)) # path to directories
    end
    println("Files in $path")
    for file in files
        println(joinpath(path, file)) # path to files
    end
end
```

```julia-repl
julia> mkpath("my/test/dir");

julia> itr = walkdir("my");

julia> (path, dirs, files) = first(itr)
("my", ["test"], String[])

julia> (path, dirs, files) = first(itr)
("my/test", ["dir"], String[])

julia> (path, dirs, files) = first(itr)
("my/test/dir", String[], String[])
```
