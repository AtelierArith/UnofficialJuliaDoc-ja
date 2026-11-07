```julia
skipchars(predicate, io::IO; linecomment=nothing)
```

ストリーム `io` を進め、`predicate` が `false` を返す、まだ読み取られていない最初の文字が次に読み取られる文字となるようにします。キーワード引数 `linecomment` が指定されている場合、その文字から次の行の先頭までのすべての文字は無視されます。

# Examples

```jldoctest
julia> buf = IOBuffer("    text")
IOBuffer(data=UInt8[...], readable=true, writable=false, seekable=true, append=false, size=8, maxsize=Inf, ptr=1, mark=-1)

julia> skipchars(isspace, buf)
IOBuffer(data=UInt8[...], readable=true, writable=false, seekable=true, append=false, size=8, maxsize=Inf, ptr=5, mark=-1)

julia> String(readavailable(buf))
"text"
```
