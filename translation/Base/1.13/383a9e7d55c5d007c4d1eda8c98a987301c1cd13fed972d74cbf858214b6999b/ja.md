```julia
!=(x, y)
≠(x,y)
```

等しくないことを比較する演算子です。常に[`==`](@ref)とは逆の結果を返します。

# Implementation

新しい型では通常、この演算子を実装せず、フォールバック定義`!=(x,y) = !(x==y)`に依存してください。

# Examples

```jldoctest
julia> 3 != 2
true

julia> "foo" ≠ "foo"
false
```
