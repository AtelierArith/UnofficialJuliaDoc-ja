```julia
x | y
```

ビット単位の OR。[three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic) を実装し、一方のオペランドが `missing`、もう一方が `false` の場合に [`missing`](@ref) を返します。

関連項目: [`&`](@ref)、[`xor`](@ref)、[`||`](@ref)。

# Examples

```jldoctest
julia> 4 | 10
14

julia> 4 | 1
5

julia> true | missing
true

julia> false | missing
missing
```
