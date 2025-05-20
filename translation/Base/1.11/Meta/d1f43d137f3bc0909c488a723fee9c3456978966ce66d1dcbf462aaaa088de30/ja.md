```
Meta.show_sexpr([io::IO,], ex)
```

式 `ex` をリスプスタイルのS式として表示します。

# 例

```jldoctest
julia> Meta.show_sexpr(:(f(x, g(y,z))))
(:call, :f, :x, (:call, :g, :y, :z))
```
