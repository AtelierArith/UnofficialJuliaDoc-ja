```julia
relpath(path::AbstractString, startpath::AbstractString = ".") -> String
```

Return a relative filepath to `path` either from the current directory or from an optional start directory. This is a path computation: the filesystem is not accessed to confirm the existence or nature of `path` or `startpath`.

On Windows, case sensitivity is applied to every part of the path except drive letters. If `path` and `startpath` refer to different drives, the absolute path of `path` is returned.
