```
delete!(collection, key)
```

指定されたキーに対するマッピングをコレクションから削除し、コレクションを返します。

# 例

```jldoctest
julia> d = Dict("a"=>1, "b"=>2)
Dict{String, Int64} with 2 entries:
  "b" => 2
  "a" => 1

julia> delete!(d, "b")
Dict{String, Int64} with 1 entry:
  "a" => 1

julia> delete!(d, "b") # dは変更されません
Dict{String, Int64} with 1 entry:
  "a" => 1
```
