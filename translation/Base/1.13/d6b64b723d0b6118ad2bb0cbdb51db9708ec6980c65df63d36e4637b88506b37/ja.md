```julia
nand(x, y)
⊼(x, y)
```

`x` と `y` のビット単位の NAND（NOT AND）です。[three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic) を実装しており、引数のいずれかが `missing` の場合は [`missing`](@ref) を返します。

中置演算子 `a ⊼ b` は `nand(a,b)` の別名です。また、Julia REPL で `\nand` または `\barwedge` を入力してタブ補完すると、`⊼` を入力できます。

# Examples

```jldoctest
julia> nand(true, false)
true

julia> nand(true, true)
false

julia> nand(true, missing)
missing

julia> false ⊼ false
true

julia> [true; true; false] .⊼ [true; false; false]
3-element BitVector:
 0
 1
 1
```
