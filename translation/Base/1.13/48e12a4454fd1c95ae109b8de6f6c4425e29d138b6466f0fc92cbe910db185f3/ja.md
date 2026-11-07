```julia
values(iterator)
```

キーと値を持つイテレータまたはコレクションの場合、値を反復するイテレータを返します。一般的なイテレータの要素は通常「値」とみなされるため、デフォルトでは引数をそのまま返します。

# Examples

```jldoctest; filter = r"^\s+\d$"m
julia> d = Dict("a"=>1, "b"=>2);

julia> values(d)
ValueIterator for a Dict{String, Int64} with 2 entries. Values:
  2
  1

julia> values([2])
1-element Vector{Int64}:
 2
```
