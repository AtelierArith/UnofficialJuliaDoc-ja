```julia
pairs(collection)
```

任意のコレクションに対して `key => value` ペアのイテレータを返します。これは、キーが配列のインデックスである配列を含みます。エントリが内部的にハッシュテーブルに格納されている場合、例えば `Dict` の場合、返される順序は異なる場合があります。しかし、`keys(a)`、`values(a)` および `pairs(a)` はすべて `a` を反復処理し、同じ順序で要素を返します。

# 例

```jldoctest
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
