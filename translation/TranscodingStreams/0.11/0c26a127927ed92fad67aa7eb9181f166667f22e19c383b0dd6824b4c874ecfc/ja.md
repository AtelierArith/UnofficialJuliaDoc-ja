```julia
transcode(
    codec::Codec,
    data::Union{Vector{UInt8},Base.CodeUnits{UInt8},Buffer},
    [output::Union{Vector{UInt8},Base.CodeUnits{UInt8},Buffer}],
)::Vector{UInt8}
```

`codec`を適用して`data`をトランスコードします。

`output`が指定されていない場合、このメソッドはそれを割り当てます。

このメソッドは`codec`を初期化または終了しないことに注意してください。これは、複数のデータをトランスコードする際に効率的ですが、[`TranscodingStreams.initialize`](@ref)と[`TranscodingStreams.finalize`](@ref)を明示的に呼び出す必要があります。

## 例

```julia
julia> using CodecZlib

julia> data = b"abracadabra";

julia> codec = ZlibCompressor();

julia> TranscodingStreams.initialize(codec)

julia> compressed = Vector{UInt8}()

julia> transcode(codec, data, compressed);

julia> TranscodingStreams.finalize(codec)

julia> codec = ZlibDecompressor();

julia> TranscodingStreams.initialize(codec)

julia> decompressed = transcode(codec, compressed);

julia> TranscodingStreams.finalize(codec)

julia> String(decompressed)
"abracadabra"

```
