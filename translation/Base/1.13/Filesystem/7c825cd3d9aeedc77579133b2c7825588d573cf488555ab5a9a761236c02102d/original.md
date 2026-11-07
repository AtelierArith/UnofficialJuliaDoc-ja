```julia
DirEntry
```

A type representing a filesystem entry that contains the name of the entry, the directory, and the raw type of the entry. The full path of the entry can be obtained lazily by accessing the `path` field. The type of the entry can be checked for by calling [`isfile`](@ref), [`isdir`](@ref), [`islink`](@ref), [`isfifo`](@ref), [`issocket`](@ref), [`ischardev`](@ref), and [`isblockdev`](@ref)
