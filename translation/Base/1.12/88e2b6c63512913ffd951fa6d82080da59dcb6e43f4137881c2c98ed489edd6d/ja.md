```julia
pop!(collection, key[, default])
```

`collection`に`key`が存在する場合は、そのマッピングを削除して返します。存在しない場合は`default`を返すか、`default`が指定されていない場合はエラーをスローします。

# 例

```jldoctest
julia> d = Dict("a"=>1, "b"=>2, "c"=>3);

julia> pop!(d, "a")
1

julia> pop!(d, "d")
ERROR: KeyError: key "d" not found
Stacktrace:
[...]

julia> pop!(d, "e", 4)
4
```
