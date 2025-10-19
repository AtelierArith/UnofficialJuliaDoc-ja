```julia
skipchars(predicate, io::IO; linecomment=nothing)
```

ストリーム `io` を進めて、次に読み取る文字が `predicate` が `false` を返す最初の残りの文字になるようにします。キーワード引数 `linecomment` が指定されている場合、その文字から次の行の開始までのすべての文字は無視されます。

# 例

```jldoctest
julia> buf = IOBuffer("    text")
IOBuffer(data=UInt8[...], readable=true, writable=false, seekable=true, append=false, size=8, maxsize=Inf, ptr=1, mark=-1)

julia> skipchars(isspace, buf)
IOBuffer(data=UInt8[...], readable=true, writable=false, seekable=true, append=false, size=8, maxsize=Inf, ptr=5, mark=-1)

julia> String(readavailable(buf))
"text"
```
