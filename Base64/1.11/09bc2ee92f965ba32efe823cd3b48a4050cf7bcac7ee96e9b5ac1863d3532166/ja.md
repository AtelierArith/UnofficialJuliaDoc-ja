```julia
Base64DecodePipe(istream)
```

新しい読み取り専用I/Oストリームを返し、`istream`から読み取ったbase64エンコードされたデータをデコードします。

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
