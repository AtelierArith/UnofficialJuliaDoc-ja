```julia
findprev(pattern::AbstractVector{<:Union{Int8,UInt8}},
         A::AbstractVector{<:Union{Int8,UInt8}},
         start::Integer)
```

位置 `start` から開始して、ベクトル `A` 内で、シーケンス `pattern` が直前に出現した位置を検索します。

!!! compat "Julia 1.6"
    このメソッドを使用するには、Julia 1.6 以降が必要です。


# Examples

```jldoctest
julia> findprev([0x52, 0x62], [0x40, 0x52, 0x62, 0x52, 0x62], 3)
2:3
```
