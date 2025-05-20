```
splitdir(path::AbstractString) -> (AbstractString, AbstractString)
```

Split a path into a tuple of the directory name and file name.

# Examples

```jldoctest
julia> splitdir("/home/myuser")
("/home", "myuser")
```
