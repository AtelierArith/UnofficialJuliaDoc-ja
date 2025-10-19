```julia
transcode(
    ::Type{C},
    data::Union{Vector{UInt8},Base.CodeUnits{UInt8}},
)::Vector{UInt8} where {C<:Codec}
```

Transcode `data` by applying a codec `C()`.

Note that this method does allocation and deallocation of `C()` in every call, which is handy but less efficient when transcoding a number of objects. `transcode(codec, data)` is a recommended method in terms of performance.

## Examples

```julia
julia> using CodecZlib

julia> data = b"abracadabra";

julia> compressed = transcode(ZlibCompressor, data);

julia> decompressed = transcode(ZlibDecompressor, compressed);

julia> String(decompressed)
"abracadabra"
```
