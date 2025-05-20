```
foreach(f, c...) -> Nothing
```

イテラブル `c` の各要素に対して関数 `f` を呼び出します。複数のイテラブル引数がある場合、`f` は要素ごとに呼び出され、いずれかのイテレータが終了するとイテレーションが停止します。

`f` の結果が必要ない場合は、`foreach(println, array)` のように [`map`](@ref) の代わりに `foreach` を使用するべきです。

# 例

```jldoctest
julia> tri = 1:3:7; res = Int[];

julia> foreach(x -> push!(res, x^2), tri)

julia> res
3-element Vector{Int64}:
  1
 16
 49

julia> foreach((x, y) -> println(x, " with ", y), tri, 'a':'z')
1 with a
4 with b
7 with c
```
