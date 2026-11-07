```julia
<<(B::BitVector, n)::BitVector
```

左ビットシフト演算子、`B << n`。`n >= 0`の場合、結果は`B`となり、要素は`n`個分後方にシフトされ、空いた部分は`false`の値で埋められます。`n < 0`の場合、要素は前方にシフトされます。`B >> -n`と同等です。

# Examples

```jldoctest
julia> B = BitVector([true, false, true, false, false])
5-element BitVector:
 1
 0
 1
 0
 0

julia> B << 1
5-element BitVector:
 0
 1
 0
 0
 0

julia> B << -1
5-element BitVector:
 0
 1
 0
 1
 0
```
