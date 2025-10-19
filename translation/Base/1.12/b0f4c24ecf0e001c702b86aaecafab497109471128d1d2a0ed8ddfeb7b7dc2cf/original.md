```julia
keys(a::AbstractDict)
```

Return an iterator over all keys in a dictionary. `collect(keys(a))` returns an array of keys. When the keys are stored internally in a hash table, as is the case for `Dict`, the order in which they are returned may vary. But `keys(a)`, `values(a)` and `pairs(a)` all iterate `a` and return the elements in the same order.

# Examples

```jldoctest
julia> D = Dict('a'=>2, 'b'=>3)
Dict{Char, Int64} with 2 entries:
  'a' => 2
  'b' => 3

julia> collect(keys(D))
2-element Vector{Char}:
 'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)
 'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)
```
