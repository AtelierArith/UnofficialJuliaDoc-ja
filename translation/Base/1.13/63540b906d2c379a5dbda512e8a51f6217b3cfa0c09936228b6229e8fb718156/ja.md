```julia
xor(x, y)
⊻(x, y)
```

`x` と `y` のビット単位の排他的論理和です。[three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic) を実装しており、引数のいずれかが `missing` の場合は [`missing`](@ref) を返します。

中置演算子 `a ⊻ b` は `xor(a,b)` の別名です。また、Julia REPL で `\xor` または `\veebar` をタブ補完すると、`⊻` を入力できます。

# Examples

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
