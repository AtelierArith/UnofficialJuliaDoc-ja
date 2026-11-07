```julia
get(collection, key, default)
```

指定したキーに対応する値を返します。キーに対応するマッピングが存在しない場合は、指定したデフォルト値を返します。

!!! compat "Julia 1.7"
    タプルと数値に対してこの関数を使用するには、Julia 1.7 以降が必要です。


# Examples

```jldoctest
julia> d = Dict("a"=>1, "b"=>2);

julia> get(d, "a", 3)
1

julia> get(d, "c", 3)
3
```
