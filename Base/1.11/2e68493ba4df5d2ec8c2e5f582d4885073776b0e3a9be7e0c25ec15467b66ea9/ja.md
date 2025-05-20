```
getindex(collection, key...)
```

指定されたキーまたはインデックスに格納されている値をコレクションから取得します。構文 `a[i,j,...]` はコンパイラによって `getindex(a, i, j, ...)` に変換されます。

関連項目としては [`get`](@ref), [`keys`](@ref), [`eachindex`](@ref) があります。

# 例

```jldoctest
julia> A = Dict("a" => 1, "b" => 2)
Dict{String, Int64} with 2 entries:
  "b" => 2
  "a" => 1

julia> getindex(A, "a")
1
```
