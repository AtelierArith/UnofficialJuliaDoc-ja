```julia
keepat!(a::Vector, m::AbstractVector{Bool})
keepat!(a::BitVector, m::AbstractVector{Bool})
```

論理インデックス指定のインプレース版 `a = a[m]` です。つまり、同じ長さのベクトル `a` と `m` に対して `keepat!(a, m)` を実行すると、対応するインデックスの `m` が `false` である要素が `a` からすべて削除されます。

# Examples

```jldoctest
julia> a = [:a, :b, :c];

julia> keepat!(a, [true, false, true])
2-element Vector{Symbol}:
 :a
 :c

julia> a
2-element Vector{Symbol}:
 :a
 :c
```
