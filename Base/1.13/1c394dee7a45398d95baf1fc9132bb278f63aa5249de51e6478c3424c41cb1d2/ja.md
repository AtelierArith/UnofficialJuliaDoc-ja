```julia
findlast(pattern::AbstractVector{<:Union{Int8,UInt8}},
         A::AbstractVector{<:Union{Int8,UInt8}})
```

配列 `A` 内で、`pattern` が最後に現れる位置を検索します。[`findprev(pattern, A, lastindex(A))`](@ref) と同等です。

# Examples

```jldoctest
julia> findlast([0x52, 0x62], [0x52, 0x62, 0x52, 0x62])
3:4
```
