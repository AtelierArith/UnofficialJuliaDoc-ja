```julia
getkey(collection, key, default)
```

`key` に一致する引数が `collection` に存在する場合は、そのキーを返します。存在しない場合は、`default` を返します。

# Examples

```jldoctest; filter = r"^\s+\S+\s+=>\s+\d$"m
julia> D = Dict('a'=>2, 'b'=>3)
Dict{Char, Int64} with 2 entries:
  'a' => 2
  'b' => 3

julia> getkey(D, 'a', 1)
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

julia> getkey(D, 'd', 'a')
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)
```
