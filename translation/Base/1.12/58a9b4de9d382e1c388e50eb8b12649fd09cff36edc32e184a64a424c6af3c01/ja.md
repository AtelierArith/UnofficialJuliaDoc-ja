```julia
xor(x, y)
⊻(x, y)
```

`x` と `y` のビット単位の排他的論理和。引数のいずれかが `missing` の場合、[`missing`](@ref) を返す [三値論理](https://en.wikipedia.org/wiki/Three-valued_logic) を実装しています。

中置演算 `a ⊻ b` は `xor(a,b)` の同義語であり、`⊻` は Julia REPL で `\xor` または `\veebar` をタブ補完することで入力できます。

# 例

```jldoctest
julia> xor(true, false)
true

julia> xor(true, true)
false

julia> xor(true, missing)
missing

julia> false ⊻ false
false

julia> [true; true; false] .⊻ [true; false; false]
3-element BitVector:
 0
 1
 0
```
