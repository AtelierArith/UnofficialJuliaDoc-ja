```julia
_readdirx(dir::AbstractString=pwd(); sort::Bool = true)::Vector{DirEntry}
```

ディレクトリ `dir`（指定されていない場合は現在の作業ディレクトリ）の内容を表す [`DirEntry`](@ref) オブジェクトのベクトルを返します。`sort` が true の場合、返されるベクトルは名前順にソートされます。

[`readdir`](@ref) とは異なり、`_readdirx` は [`DirEntry`](@ref) オブジェクトを返します。これらのオブジェクトには、ファイル名、そのファイルが含まれるディレクトリ、およびディレクトリの走査時に判定されたファイルの種類が含まれます。そのため、返されたオブジェクトに対して [`isfile`](@ref)、[`isdir`](@ref)、[`islink`](@ref)、[`isfifo`](@ref)、[`issocket`](@ref)、[`ischardev`](@ref)、[`isblockdev`](@ref) を呼び出しても、追加の stat 呼び出しは発生しません。ただし、一部のファイルシステムでは、stat 呼び出しなしにファイルの種類を判定できません。その場合、[`DirEntry`](@ref)) オブジェクトの `rawtype` フィールドは 0（`UV_DIRENT_UNKNOWN`）となり、[`isfile`](@ref) などは `stat` 呼び出しにフォールバックします。

```julia
for obj in _readdirx()
    isfile(obj) && println("$(obj.name) is a file with path $(obj.path)")
end
```
