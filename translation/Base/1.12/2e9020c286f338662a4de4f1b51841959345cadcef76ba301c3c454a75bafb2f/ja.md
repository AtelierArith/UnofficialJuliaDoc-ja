```julia
findprev(pattern::AbstractVector{<:Union{Int8,UInt8}},
         A::AbstractVector{<:Union{Int8,UInt8}},
         start::Integer)
```

ベクトル `A` の中で、位置 `start` から始めて、シーケンス `pattern` の前の出現を見つけます。

!!! compat "Julia 1.6"
    このメソッドは少なくとも Julia 1.6 を必要とします。


# 例

```jldoctest
julia> findprev([0x52, 0x62], [0x40, 0x52, 0x62, 0x52, 0x62], 3)
2:3
```
