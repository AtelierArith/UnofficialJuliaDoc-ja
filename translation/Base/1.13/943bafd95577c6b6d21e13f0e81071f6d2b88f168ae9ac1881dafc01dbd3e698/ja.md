```julia
truncate(file, n)
```

第1引数で指定されたファイルまたはバッファのサイズを、正確に`n`バイトに変更します。ファイルまたはバッファを拡張する場合、これまで割り当てられていなかった領域は'\0'で埋められます。

# Examples

```jldoctest
julia> io = IOBuffer();

julia> write(io, "JuliaLang is a GitHub organization.")
35

julia> truncate(io, 15)
IOBuffer(data=UInt8[...], readable=true, writable=true, seekable=true, append=false, size=15, maxsize=Inf, ptr=16, mark=-1)

julia> takestring!(io)
"JuliaLang is a "

julia> io = IOBuffer();

julia> write(io, "JuliaLang is a GitHub organization.");

julia> truncate(io, 40);

julia> takestring!(io)
"JuliaLang is a GitHub organization.\0\0\0\0\0"
```
