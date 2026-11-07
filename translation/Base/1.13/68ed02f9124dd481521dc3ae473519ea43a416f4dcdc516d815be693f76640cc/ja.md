```julia
haskey(collection, key)::Bool
```

コレクションに指定した`key`のマッピングがあるかどうかを判定します。

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
