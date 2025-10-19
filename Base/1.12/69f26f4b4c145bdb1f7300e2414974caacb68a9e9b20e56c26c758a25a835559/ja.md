```julia
IOBuffer([data::AbstractVector{UInt8}]; keywords...) -> IOBuffer
```

メモリ内のI/Oストリームを作成します。これは、既存の配列で操作することもできます。

オプションのキーワード引数を取ることができます：

  * `read`, `write`, `append`: 操作をバッファに制限します。詳細は`open`を参照してください。
  * `truncate`: バッファサイズをゼロ長に切り詰めます。
  * `maxsize`: バッファが成長できないサイズを指定します。
  * `sizehint`: バッファの容量を提案します（`data`は`sizehint!(data, size)`を実装する必要があります）。

`data`が指定されていない場合、バッファはデフォルトで読み取り可能かつ書き込み可能です。

!!! warning "`write=true`で`IOBuffer`に`data`をスクラッチスペースとして渡すと予期しない動作を引き起こす可能性があります"
    一度`IOBuffer`で`write`が呼び出されると、以前の`data`への参照は無効化されたと考えるのが最善です。実際、`IOBuffer`は`take!`が呼ばれるまでこのデータを「所有」します。`data`への間接的な変更は、`IOBuffer`が期待する抽象を壊すことによって未定義の動作を引き起こす可能性があります。`write=true`の場合、IOBufferは任意のオフセットにデータを保存し、他のオフセットに任意の値を残す可能性があります。`maxsize > length(data)`の場合、IOBufferはデータを完全に再割り当てする可能性があり、これは`array`への未解決のバインディングにおいて可視化される場合とされない場合があります。


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
