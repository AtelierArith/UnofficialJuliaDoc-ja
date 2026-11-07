```julia
⊈(a, b)::Bool
⊉(b, a)::Bool
```

`⊆` と `⊇` の否定。つまり、`a` が `b` の部分集合ではないことを確認します。

[`issubset`](@ref)（`⊆`）、[`⊊`](@ref) も参照してください。

# Examples

```jldoctest
julia> (1, 2) ⊈ (2, 3)
true

julia> (1, 2) ⊈ (1, 2, 3)
false
```
