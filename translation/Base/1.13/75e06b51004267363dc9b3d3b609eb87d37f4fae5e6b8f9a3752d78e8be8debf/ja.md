```julia
setindex!(collection, value, key...)
```

指定した値を、コレクション内の指定したキーまたはインデックスに格納します。構文 `a[i,j,...] = x` は、コンパイラーによって `(setindex!(a, x, i, j, ...); x)` に変換されます。

# Examples

```jldoctest; filter = r"^\s+\S+\s+=>\s+\d$"m
julia> a = Dict("a"=>1)
Dict{String, Int64} with 1 entry:
  "a" => 1

julia> setindex!(a, 2, "b")
Dict{String, Int64} with 2 entries:
  "b" => 2
  "a" => 1
```
