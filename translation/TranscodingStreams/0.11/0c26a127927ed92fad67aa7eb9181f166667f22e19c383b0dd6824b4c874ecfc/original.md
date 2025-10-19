```julia
transcode(
    codec::Codec,
    data::Union{Vector{UInt8},Base.CodeUnits{UInt8},Buffer},
    [output::Union{Vector{UInt8},Base.CodeUnits{UInt8},Buffer}],
)::Vector{UInt8}
```

Transcode `data` by applying `codec`.

If `output` is unspecified, then this method will allocate it.

Note that this method does not initialize or finalize `codec`. This is efficient when you transcode a number of pieces of data, but you need to call [`TranscodingStreams.initialize`](@ref) and [`TranscodingStreams.finalize`](@ref) explicitly.

## Examples

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
