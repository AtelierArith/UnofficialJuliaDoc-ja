```julia
haskey(collection, key)::Bool
```

コレクションに、指定した `key` に対応するマッピングがあるかどうかを判定します。

# Examples

```jldoctest; filter = r"^\s+\S+\s+=>\s+\d$"m
julia> D = Dict('a'=>2, 'b'=>3)
Dict{Char, Int64} with 2 entries:
  'a' => 2
  'b' => 3

julia> haskey(D, 'a')
true

julia> haskey(D, 'c')
false
```
