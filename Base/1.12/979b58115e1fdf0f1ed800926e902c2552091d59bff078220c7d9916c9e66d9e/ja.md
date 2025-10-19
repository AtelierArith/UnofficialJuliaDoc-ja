```julia
get(collection, key, default)
```

指定されたキーに対して保存されている値を返すか、キーに対するマッピングが存在しない場合は指定されたデフォルト値を返します。

!!! compat "Julia 1.7"
    タプルと数値の場合、この関数は少なくともJulia 1.7を必要とします。


# 例

```jldoctest
julia> d = Dict("a"=>1, "b"=>2);

julia> get(d, "a", 3)
1

julia> get(d, "c", 3)
3
```
