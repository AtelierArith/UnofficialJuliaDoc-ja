```julia
getindex(collection, key...)
```

コレクション内の指定したキーまたはインデックスに格納されている値を取得します。構文 `a[i,j,...]` は、コンパイラーによって `getindex(a, i, j, ...)` に変換されます。

関連項目: [`get`](@ref)、[`keys`](@ref)、[`eachindex`](@ref)。

# Examples

```jldoctest; filter = r"^\s+\S+\s+=>\s+\d$"m
julia> A = Dict("a" => 1, "b" => 2)
Dict{String, Int64} with 2 entries:
  "b" => 2
  "a" => 1

julia> getindex(A, "a")
1
```
