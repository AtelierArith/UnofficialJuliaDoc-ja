```julia
UnitRange{T<:Real}
```

`start` と `stop` の型 `T` によってパラメータ化された範囲で、`start` から `stop` を超えるまで `1` ずつ間隔を空けた要素で満たされています。`a:b` という構文は、`a` と `b` の両方が `Integer` の場合に `UnitRange` を作成します。

# 例

```jldoctest
julia> collect(UnitRange(2.3, 5.2))
3-element Vector{Float64}:
 2.3
 3.3
 4.3

julia> typeof(1:10)
UnitRange{Int64}
```
