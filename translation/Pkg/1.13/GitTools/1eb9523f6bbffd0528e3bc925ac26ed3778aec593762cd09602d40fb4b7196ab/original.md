```julia
contains_files(root::AbstractString)
```

Helper function to determine whether a directory contains files; e.g. it is a direct parent of a file or it contains some other directory that itself is a direct parent of a file. This is used to exclude directories from tree hashing.
