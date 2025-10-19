```julia
isfile(path) -> Bool
isfile(path_elements...) -> Bool
```

Return `true` if `path` points to a regular file, `false` otherwise.

# Examples

```jldoctest
julia> isfile(homedir())
false

julia> filename = "test_file.txt";

julia> write(filename, "Hello world!");

julia> isfile(filename)
true

julia> rm(filename);

julia> isfile(filename)
false
```

See also [`isdir`](@ref) and [`ispath`](@ref).
