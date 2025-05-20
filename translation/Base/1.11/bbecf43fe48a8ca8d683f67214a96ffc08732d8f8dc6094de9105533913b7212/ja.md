```
filter(f, d::AbstractDict)
```

`f`が`false`である要素を削除して、`d`のコピーを返します。関数`f`には`key=>value`ペアが渡されます。

# 例

```jldoctest
julia> d = Dict(1=>"a", 2=>"b")
Dict{Int64, String} with 2 entries:
  2 => "b"
  1 => "a"

julia> filter(p->isodd(p.first), d)
Dict{Int64, String} with 1 entry:
  1 => "a"
```
