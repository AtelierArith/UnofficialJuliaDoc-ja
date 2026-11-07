```julia
nor(x, y)
⊽(x, y)
```

`x` と `y` のビット単位の NOR（OR の否定）です。[three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic) を実装しており、一方の引数が `missing` で、もう一方が `true` でない場合に [`missing`](@ref) を返します。

中置演算子 `a ⊽ b` は `nor(a,b)` の別名です。Julia REPL で `\nor` または `\barvee` をタブ補完すると、`⊽` を入力できます。

# Examples

```jldoctest
julia> nor(true, false)
false

julia> nor(true, true)
false

julia> nor(true, missing)
false

julia> false ⊽ false
true

julia> false ⊽ missing
missing

julia> [true; true; false] .⊽ [true; false; false]
3-element BitVector:
 0
 0
 1
```
