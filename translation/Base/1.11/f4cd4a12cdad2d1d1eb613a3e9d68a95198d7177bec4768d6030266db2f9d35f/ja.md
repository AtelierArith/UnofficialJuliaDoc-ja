```
⊈(a, b) -> Bool
⊉(b, a) -> Bool
```

`⊆` と `⊇` の否定、すなわち `a` が `b` の部分集合でないことを確認します。

関連情報として [`issubset`](@ref) (`⊆`)、[`⊊`](@ref) を参照してください。

# 例

```jldoctest
julia> (1, 2) ⊈ (2, 3)
true

julia> (1, 2) ⊈ (1, 2, 3)
false
```
