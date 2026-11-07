```julia
pairs(collection)
```

キーの集合を値の集合に対応付けるコレクションについて、`key => value` のペアを返すイテレーターです。配列もこれに含まれ、配列のキーはインデックスです。`Dict` のように、エントリーが内部的にハッシュテーブルに格納されている場合、返される順序は変わることがあります。一方、`keys(a)`、`values(a)`、`pairs(a)` はいずれも `a` を反復し、同じ順序で要素を返します。

# Examples

```jldoctest; filter = r"^\s+\S+\s+=>\s+\d$"m
julia> a = Dict(zip(["a", "b", "c"], [1, 2, 3]))
Dict{String, Int64} with 3 entries:
  "c" => 3
  "b" => 2
  "a" => 1

julia> pairs(a)
Dict{String, Int64} with 3 entries:
  "c" => 3
  "b" => 2
  "a" => 1

julia> foreach(println, pairs(["a", "b", "c"]))
1 => "a"
2 => "b"
3 => "c"

julia> (;a=1, b=2, c=3) |> pairs |> collect
3-element Vector{Pair{Symbol, Int64}}:
 :a => 1
 :b => 2
 :c => 3

julia> (;a=1, b=2, c=3) |> collect
3-element Vector{Int64}:
 1
 2
 3
```
