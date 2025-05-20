```
get!(collection, key, default)
```

指定されたキーに対して保存されている値を返します。キーに対するマッピングが存在しない場合は、`key => default`を保存し、`default`を返します。

# 例

```jldoctest
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
