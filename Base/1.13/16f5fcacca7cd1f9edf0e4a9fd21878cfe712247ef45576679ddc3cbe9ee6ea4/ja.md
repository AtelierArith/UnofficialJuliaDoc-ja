```julia
<(x, y)
```

小なり比較演算子。[`isless`](@ref)にフォールバックします。浮動小数点数のNaN値の性質上、この演算子が実装するのは半順序です。

# Implementation

標準的な半順序を持つ新しい型では、その型の2つの引数を取るこの関数を実装してください。標準的な全順序を持つ型では、代わりに[`isless`](@ref)を実装してください。

[`isunordered`](@ref)も参照してください。

# Examples

```jldoctest
julia> 'a' < 'b'
true

julia> "abc" < "abd"
true

julia> 5 < 3
false
```
