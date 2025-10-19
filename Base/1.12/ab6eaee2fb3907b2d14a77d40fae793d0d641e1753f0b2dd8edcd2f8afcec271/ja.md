```julia
filter!(f, d::AbstractDict)
```

`d`を更新し、`f`が`false`である要素を削除します。関数`f`には`key=>value`ペアが渡されます。

# 例

```jldoctest
julia> d = Dict(1=>"a", 2=>"b", 3=>"c")
Dict{Int64, String} with 3 entries:
  2 => "b"
  3 => "c"
  1 => "a"

julia> filter!(p->isodd(p.first), d)
Dict{Int64, String} with 2 entries:
  3 => "c"
  1 => "a"
```
