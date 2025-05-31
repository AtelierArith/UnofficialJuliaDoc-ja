```
findlast(pattern::AbstractVector{<:Union{Int8,UInt8}},
         A::AbstractVector{<:Union{Int8,UInt8}})
```

配列 `A` の中で `pattern` の最後の出現を見つけます。これは [`findprev(pattern, A, lastindex(A))`](@ref) と同等です。

# 例

```jldoctest
julia> findlast([0x52, 0x62], [0x52, 0x62, 0x52, 0x62])
3:4
```
