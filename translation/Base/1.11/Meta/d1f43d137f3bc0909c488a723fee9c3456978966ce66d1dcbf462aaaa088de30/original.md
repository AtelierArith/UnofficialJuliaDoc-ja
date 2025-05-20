```
Meta.show_sexpr([io::IO,], ex)
```

Show expression `ex` as a lisp style S-expression.

# Examples

```jldoctest
julia> Meta.show_sexpr(:(f(x, g(y,z))))
(:call, :f, :x, (:call, :g, :y, :z))
```
