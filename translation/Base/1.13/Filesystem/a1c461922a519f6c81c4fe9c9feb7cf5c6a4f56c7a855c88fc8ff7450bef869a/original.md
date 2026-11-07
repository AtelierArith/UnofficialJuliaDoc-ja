```julia
_readdirx(dir::AbstractString=pwd(); sort::Bool = true)::Vector{DirEntry}
```

Return a vector of [`DirEntry`](@ref) objects representing the contents of the directory `dir`, or the current working directory if not given. If `sort` is true, the returned vector is sorted by name.

Unlike [`readdir`](@ref), `_readdirx` returns [`DirEntry`](@ref) objects, which contain the name of the file, the directory it is in, and the type of the file which is determined during the directory scan. This means that calls to [`isfile`](@ref), [`isdir`](@ref), [`islink`](@ref), [`isfifo`](@ref), [`issocket`](@ref), [`ischardev`](@ref), and [`isblockdev`](@ref) can be made on the returned objects without further stat calls. However, for some filesystems, the type of the file cannot be determined without a stat call. In these cases the `rawtype` field of the [`DirEntry`](@ref)) object will be 0 (`UV_DIRENT_UNKNOWN`) and [`isfile`](@ref) etc. will fall back to a `stat` call.

```julia
for obj in _readdirx()
    isfile(obj) && println("$(obj.name) is a file with path $(obj.path)")
end
```
