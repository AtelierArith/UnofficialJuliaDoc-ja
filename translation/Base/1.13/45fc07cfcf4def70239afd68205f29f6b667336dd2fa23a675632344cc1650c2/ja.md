```julia
filter(f, d::AbstractDict)
```

`d` のコピーを返します。`f` が `false` である要素は取り除きます。この関数 `f` には、`key=>value` のペアを渡します。

# Examples

```jldoctest; filter = r"^\s+\d\s+=>\s+\S+$"m
julia> d = Dict(1=>"a", 2=>"b")
Dict{Int64, String} with 2 entries:
  2 => "b"
  1 => "a"

julia> filter(p->isodd(p.first), d)
Dict{Int64, String} with 1 entry:
  1 => "a"
```
