```
isa(x, type) -> Bool
```

`x`が指定された`type`であるかどうかを判断します。中置演算子としても使用できます。例えば、`x isa type`のように。

# 例

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
