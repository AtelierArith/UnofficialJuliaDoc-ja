```
readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
```

ストリームから最大 `nb` バイトを読み取り、`b` に格納し、読み取ったバイト数を返します。必要に応じて `b` のサイズは増加します（つまり、`nb` が `length(b)` より大きく、十分なバイトが読み取れた場合）、ただし減少することはありません。
