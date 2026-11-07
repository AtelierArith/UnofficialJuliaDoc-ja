```julia
getkey(collection, key, default)
```

`collection` に `key` に一致するキーが存在する場合はそのキーを返し、存在しない場合は `default` を返します。

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
