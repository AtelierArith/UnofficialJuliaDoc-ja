```julia
findfirst(pattern::AbstractVector{<:Union{Int8,UInt8}},
          A::AbstractVector{<:Union{Int8,UInt8}})
```

ベクトル `A` 内で、シーケンス `pattern` が最初に現れる位置を検索します。

!!! compat "Julia 1.6"
    このメソッドを使用するには、Julia 1.6 以降が必要です。


# Examples

```jldoctest
julia> findfirst([0x52, 0x62], [0x40, 0x52, 0x62, 0x63])
2:3
```
