```
Base64DecodePipe(istream)
```

`istream` から読み取った base64 エンコードされたデータをデコードする新しい読み取り専用 I/O ストリームを返します。

# 例

```jldoctest
julia> io = IOBuffer();

julia> iob64_decode = Base64DecodePipe(io);

julia> write(io, "SGVsbG8h")
8

julia> seekstart(io);

julia> String(read(iob64_decode))
"Hello!"
```
