```julia
rm(path::AbstractString; force::Bool=false, recursive::Bool=false)
```

指定されたパスにあるファイル、リンク、または空のディレクトリを削除します。`force=true` が渡された場合、存在しないパスはエラーとして扱われません。`recursive=true` が渡され、パスがディレクトリの場合は、その内容をすべて再帰的に削除します。

# Examples

```jldoctest
julia> mkpath("my/test/dir");

julia> rm("my", recursive=true)

julia> rm("this_file_does_not_exist", force=true)

julia> rm("this_file_does_not_exist")
ERROR: IOError: unlink("this_file_does_not_exist"): no such file or directory (ENOENT)
Stacktrace:
[...]
```
