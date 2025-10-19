```julia
nor(x, y)
⊽(x, y)
```

`x` と `y` のビット単位のノル（not or）。[三値論理](https://en.wikipedia.org/wiki/Three-valued_logic)を実装しており、引数の一方が `missing` で他方が `true` でない場合は [`missing`](@ref) を返します。

中置演算子 `a ⊽ b` は `nor(a,b)` の同義語であり、`⊽` は Julia REPL で `\nor` または `\barvee` をタブ補完することで入力できます。

# 例

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
