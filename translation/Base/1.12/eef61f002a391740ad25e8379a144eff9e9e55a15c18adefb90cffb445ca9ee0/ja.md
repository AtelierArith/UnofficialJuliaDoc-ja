```julia
keepat!(a::Vector, m::AbstractVector{Bool})
keepat!(a::BitVector, m::AbstractVector{Bool})
```

論理インデックスのインプレースバージョン `a = a[m]`。つまり、長さが等しいベクトル `a` と `m` に対して `keepat!(a, m)` を実行すると、対応するインデックスで `m` が `false` の `a` のすべての要素が削除されます。

# 例

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
