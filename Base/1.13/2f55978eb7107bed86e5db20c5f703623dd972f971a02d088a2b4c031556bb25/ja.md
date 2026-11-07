```julia
IOBuffer([data::AbstractVector{UInt8}]; keywords...)::IOBuffer
```

メモリ上に I/O ストリームを作成します。既存の配列を使用することもできます。

次のキーワード引数を省略可能な形で指定できます。

  * `read`、`write`、`append`: 操作をバッファー内に制限します。詳細は `open` を参照してください。
  * `truncate`: バッファーのサイズをゼロに切り詰めます。
  * `maxsize`: バッファーを拡張できる上限サイズを指定します。
  * `sizehint`: バッファーの容量を指定します（`data` は `sizehint!(data, size)` を実装している必要があります）。

`data` を指定しない場合、バッファーはデフォルトで読み書き可能になります。

!!! warning "`write=true` を指定して `data` を `IOBuffer` のスクラッチ領域として渡すと、予期しない動作が起こることがあります"
    `IOBuffer` に対して `write` を呼び出した後は、`data` への以前の参照は無効になったものと考えるのが最善です。実質的に、`take!` が呼び出されるまで、`IOBuffer` がこのデータを「所有」します。`data` を間接的に変更すると、`IOBuffer` が前提とする抽象化が損なわれ、未定義の動作につながる可能性があります。`write=true` の場合、IOBuffer は任意のオフセットにデータを格納し、ほかのオフセットには任意の値を残すことがあります。`maxsize > length(data)` の場合、IOBuffer はデータ全体を再割り当てすることがあります。その結果は、`array` への既存のバインディングから見える場合もあれば、見えない場合もあります。


# Examples

```jldoctest
julia> io = IOBuffer();

julia> write(io, "JuliaLang is a GitHub organization.", " It has many members.")
56

julia> takestring!(io)
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

julia> takestring!(io)
"JuliaLang is a GitHub organization"

julia> length(read(IOBuffer(b"data", read=true, truncate=false)))
4

julia> length(read(IOBuffer(b"data", read=true, truncate=true)))
0
```
