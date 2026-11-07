```julia
isascii(cu::AbstractVector{CU}) where {CU <: Integer}::Bool
```

ベクトル内のすべての値がASCII文字セット（0x00〜0x7f）に属するかどうかをテストします。この関数は、高速なASCIIチェックを必要とする他の文字列実装での使用を想定しています。
