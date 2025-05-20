```
<:(T1, T2)
```

サブタイプ演算子: 型 `T1` のすべての値が型 `T2` の値でもある場合に限り `true` を返します。

# 例

```jldoctest
julia> Float64 <: AbstractFloat
true

julia> Vector{Int} <: AbstractArray
true

julia> Matrix{Float64} <: Matrix{AbstractFloat}
false
```
