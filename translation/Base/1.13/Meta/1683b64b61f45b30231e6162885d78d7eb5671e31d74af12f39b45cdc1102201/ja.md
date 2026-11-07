```julia
Meta.show_sexpr([io::IO,], ex)
```

式 `ex` を Lisp 形式の S 式として表示します。

# Examples

```jldoctest
julia> Meta.show_sexpr(:(f(x, g(y,z))))
(:call, :f, :x, (:call, :g, :y, :z))
```
