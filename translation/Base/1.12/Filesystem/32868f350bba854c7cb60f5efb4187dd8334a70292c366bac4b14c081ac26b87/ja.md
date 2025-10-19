```julia
splitdir(path::AbstractString) -> (AbstractString, AbstractString)
```

パスをディレクトリ名とファイル名のタプルに分割します。

# 例

```jldoctest
julia> splitdir("/home/myuser")
("/home", "myuser")
```
