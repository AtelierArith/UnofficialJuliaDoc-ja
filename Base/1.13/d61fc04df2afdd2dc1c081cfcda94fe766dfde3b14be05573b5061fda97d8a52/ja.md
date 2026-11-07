```julia
findnext(pattern::AbstractVector{<:Union{Int8,UInt8}},
         A::AbstractVector{<:Union{Int8,UInt8}},
         start::Integer)
```

位置 `start` から開始して、ベクトル `A` 内でシーケンス `pattern` が次に現れる位置を検索します。

!!! compat "Julia 1.6"
    このメソッドを使用するには、Julia 1.6 以降が必要です。


# Examples

```jldoctest
julia> findnext([0x52, 0x62], [0x52, 0x62, 0x72], 3) === nothing
true

julia> findnext([0x52, 0x62], [0x40, 0x52, 0x62, 0x52, 0x62], 3)
4:5
```
