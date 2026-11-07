```julia
x & y
```

ビット単位の AND。[three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic) を実装し、一方のオペランドが `missing`、もう一方が `true` の場合に [`missing`](@ref) を返します。関数呼び出し形式では、括弧を付けます: `(&)(x, y)`。

関連項目: [`|`](@ref)、[`xor`](@ref)、[`&&`](@ref)。

# Examples

```jldoctest
julia> 4 & 10
0

julia> 4 & 12
4

julia> true & missing
missing

julia> false & missing
false
```
