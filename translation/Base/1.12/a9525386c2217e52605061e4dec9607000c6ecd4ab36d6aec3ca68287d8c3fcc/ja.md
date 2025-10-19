```julia
values(iterator)
```

キーと値を持つイテレータまたはコレクションに対して、値のイテレータを返します。この関数はデフォルトで引数をそのまま返します。一般的なイテレータの要素は通常「値」と見なされるためです。

# 例

```jldoctest
julia> d = Dict("a"=>1, "b"=>2);

julia> values(d)
ValueIterator for a Dict{String, Int64} with 2 entries. Values:
  2
  1

julia> values([2])
1-element Vector{Int64}:
 2
```
