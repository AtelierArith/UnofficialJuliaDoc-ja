```julia
Base64DecodePipe(istream)
```

`istream`から読み込んだBase64エンコードデータをデコードする、新しい読み取り専用I/Oストリームを返します。

# Examples

```jldoctest
julia> io = IOBuffer();

julia> iob64_decode = Base64DecodePipe(io);

julia> write(io, "SGVsbG8h")
8

julia> seekstart(io);

julia> String(read(iob64_decode))
"Hello!"
```
