```
isascii(cu::AbstractVector{CU}) where {CU <: Integer} -> Bool
```

ベクター内のすべての値がASCII文字セット（0x00から0x7f）に属するかどうかをテストします。この関数は、高速なASCIIチェックが必要な他の文字列実装によって使用されることを意図しています。
