```julia
>>(B::BitVector, n)::BitVector
```

右ビットシフト演算子、`B >> n`。`n >= 0`の場合、結果は`n`個分前方にシフトされ、空いた要素には`false`値が入った`B`となります。`n < 0`の場合、要素は後方にシフトされます。`B << -n`と同等です。

# Examples

```jldoctest
julia> B = BitVector([true, false, true, false, false])
5-element BitVector:
 1
 0
 1
 0
 0

julia> B >> 1
5-element BitVector:
 0
 1
 0
 1
 0

julia> B >> -1
5-element BitVector:
 0
 1
 0
 0
 0
```
