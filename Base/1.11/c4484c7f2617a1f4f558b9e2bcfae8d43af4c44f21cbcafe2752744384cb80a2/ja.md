```
truncate(file, n)
```

最初の引数で指定されたファイルまたはバッファのサイズを正確に `n` バイトに変更し、ファイルまたはバッファが拡張される場合は、以前に未割り当てのスペースを '\0' で埋めます。

# 例

```jldoctest
julia> io = IOBuffer();

julia> write(io, "JuliaLang is a GitHub organization.")
35

julia> truncate(io, 15)
IOBuffer(data=UInt8[...], readable=true, writable=true, seekable=true, append=false, size=15, maxsize=Inf, ptr=16, mark=-1)

julia> String(take!(io))
"JuliaLang is a "

julia> io = IOBuffer();

julia> write(io, "JuliaLang is a GitHub organization.");

julia> truncate(io, 40);

julia> String(take!(io))
"JuliaLang is a GitHub organization.\0\0\0\0\0"
```
