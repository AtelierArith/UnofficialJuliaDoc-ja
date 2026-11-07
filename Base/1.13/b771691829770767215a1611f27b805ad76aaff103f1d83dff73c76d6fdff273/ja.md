```julia
get!(collection, key, default)
```

指定されたキーに対応する値を返します。キーに対応するマッピングが存在しない場合は、`key => default`を格納して、`default`を返します。

# Examples

```jldoctest; filter = r"^\s+\S+\s+=>\s+\d$"m
julia> d = Dict("a"=>1, "b"=>2, "c"=>3);

julia> get!(d, "a", 5)
1

julia> get!(d, "d", 4)
4

julia> d
Dict{String, Int64} with 4 entries:
  "c" => 3
  "b" => 2
  "a" => 1
  "d" => 4
```
