```julia
splitdrive(path::AbstractString) -> (drive::AbstractString, path::AbstractString)
```

On Windows, split a path into the drive letter part and the path part. On Unix systems, the first component is always the empty string.
