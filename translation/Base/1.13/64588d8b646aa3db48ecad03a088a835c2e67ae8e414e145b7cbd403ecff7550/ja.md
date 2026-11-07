```julia
>=(x, y)
≥(x,y)
```

以上であることを比較する演算子。`y <= x` にフォールバックします。

# Implementation

新しい型では、この関数ではなく [`<=`](@ref) の実装を優先し、フォールバック定義 `>=(x, y) = y <= x` を利用してください。

さらに、多くの場合は [`<`](@ref) と [`==`](@ref) だけを実装し、`<=` と `>=` の両方のフォールバック定義を利用すれば十分です。

# Examples

```jldoctest
julia> 'a' >= 'b'
false

julia> 7 ≥ 7 ≥ 3
true

julia> "abc" ≥ "abc"
true

julia> 5 >= 3
true
```
