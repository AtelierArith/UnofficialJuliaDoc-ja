```
transcode(
    ::Type{C},
    data::Union{Vector{UInt8},Base.CodeUnits{UInt8}},
)::Vector{UInt8} where {C<:Codec}
```

コーデック `C()` を適用して `data` をトランスコードします。

このメソッドは、毎回の呼び出しで `C()` の割り当てと解放を行うため便利ですが、多数のオブジェクトをトランスコードする際には効率が低下します。パフォーマンスの観点からは `transcode(codec, data)` が推奨されるメソッドです。

## 例

```julia
julia> using CodecZlib

julia> data = b"abracadabra";

julia> compressed = transcode(ZlibCompressor, data);

julia> decompressed = transcode(ZlibDecompressor, compressed);

julia> String(decompressed)
"abracadabra"
```
