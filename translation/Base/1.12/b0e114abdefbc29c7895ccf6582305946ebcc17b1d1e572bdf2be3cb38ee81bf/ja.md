```julia
readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
```

`stream` から `b` に最大 `nb` バイトを読み込み、読み取ったバイト数を返します。必要に応じて `b` のサイズは増加します（つまり、`nb` が `length(b)` より大きく、十分なバイトが読み取れた場合）、ただし減少することはありません。
