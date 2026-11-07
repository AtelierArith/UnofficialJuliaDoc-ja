```julia
splitdir(path::AbstractString) -> (dir::AbstractString, file::AbstractString)
```

パスをディレクトリ名とファイル名のタプルに分割します。

# Examples

```jldoctest
julia> splitdir("/home/myuser")
("/home", "myuser")
```
