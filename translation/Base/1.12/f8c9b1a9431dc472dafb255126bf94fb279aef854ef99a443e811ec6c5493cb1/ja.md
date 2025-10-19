```julia
nand(x, y)
⊼(x, y)
```

`x` と `y` のビット単位の nand (not and)。引数の一方が `missing` の場合、[`missing`](@ref) を返す [三値論理](https://en.wikipedia.org/wiki/Three-valued_logic) を実装しています。

中置演算 `a ⊼ b` は `nand(a,b)` の同義語であり、`⊼` は Julia REPL で `\nand` または `\barwedge` をタブ補完することで入力できます。

# 例

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
