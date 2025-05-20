```
setindex!(collection, value, key...)
```

指定されたキーまたはインデックス内のコレクションに指定された値を格納します。構文 `a[i,j,...] = x` はコンパイラによって `(setindex!(a, x, i, j, ...); x)` に変換されます。

# 例

```jldoctest
julia> a = Dict("a"=>1)
Dict{String, Int64} with 1 entry:
  "a" => 1

julia> setindex!(a, 2, "b")
Dict{String, Int64} with 2 entries:
  "b" => 2
  "a" => 1
```
