```
IOBuffer([data::AbstractVector{UInt8}]; keywords...) -> IOBuffer
```

メモリ内のI/Oストリームを作成します。これは、既存の配列で操作することもできます。

オプションのキーワード引数を取ることができます：

  * `read`, `write`, `append`: 操作をバッファに制限します。詳細は`open`を参照してください。
  * `truncate`: バッファサイズをゼロ長に切り詰めます。
  * `maxsize`: バッファが成長できないサイズを指定します。
  * `sizehint`: バッファの容量を提案します（`data`は`sizehint!(data, size)`を実装する必要があります）。

`data`が指定されていない場合、バッファはデフォルトで読み取り可能かつ書き込み可能です。

# 例

```jldoctest
julia> io = IOBuffer();

julia> write(io, "JuliaLang is a GitHub organization.", " It has many members.")
56

julia> String(take!(io))
"JuliaLang is a GitHub organization. It has many members."

julia> io = IOBuffer(b"JuliaLang is a GitHub organization.")
IOBuffer(data=UInt8[...], readable=true, writable=false, seekable=true, append=false, size=35, maxsize=Inf, ptr=1, mark=-1)

julia> read(io, String)
"JuliaLang is a GitHub organization."

julia> write(io, "This isn't writable.")
ERROR: ArgumentError: ensureroom failed, IOBuffer is not writeable

julia> io = IOBuffer(UInt8[], read=true, write=true, maxsize=34)
IOBuffer(data=UInt8[...], readable=true, writable=true, seekable=true, append=false, size=0, maxsize=34, ptr=1, mark=-1)

julia> write(io, "JuliaLang is a GitHub organization.")
34

julia> String(take!(io))
"JuliaLang is a GitHub organization"

julia> length(read(IOBuffer(b"data", read=true, truncate=false)))
4

julia> length(read(IOBuffer(b"data", read=true, truncate=true)))
0
```
