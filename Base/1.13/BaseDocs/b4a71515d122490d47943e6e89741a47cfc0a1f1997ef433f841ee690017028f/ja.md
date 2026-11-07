```julia
isa(x, type)::Bool
```

`x`が、指定された`type`であるかどうかを判定します。中置演算子としても使用できます。例：`x isa type`。

# Examples

```jldoctest
julia> isa(1, Int)
true

julia> isa(1, Matrix)
false

julia> isa(1, Char)
false

julia> isa(1, Number)
true

julia> 1 isa Number
true
```
