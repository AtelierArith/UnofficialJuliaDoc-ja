```julia
readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
```

`stream` から最大 `nb` バイトを `b` に読み込み、読み取ったバイト数を返します。必要に応じて（つまり、`nb` が `length(b)` より大きく、十分なバイトを読み取れる場合）、`b` のサイズは拡張されますが、縮小されることはありません。
