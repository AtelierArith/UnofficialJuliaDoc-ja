```julia
!(x)
```

ブール値の否定。[three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic)を実装し、`x`が`missing`の場合に[`missing`](@ref)を返します。

ビット単位の否定については、[`~`](@ref)も参照してください。

# Examples

```jldoctest
julia> !true
false

julia> !false
true

julia> !missing
missing

julia> .![true false true]
1×3 BitMatrix:
 0  1  0
```
