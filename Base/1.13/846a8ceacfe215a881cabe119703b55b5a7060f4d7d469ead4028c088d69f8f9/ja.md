```julia
>(x, y)
```

より大きい比較演算子。`y < x`にフォールバックします。

# Implementation

一般に、新しい型ではこの関数ではなく[`<`](@ref)を実装し、フォールバック定義`>(x, y) = y < x`を利用してください。

# Examples

```jldoctest
julia> 'a' > 'b'
false

julia> 7 > 3 > 1
true

julia> "abc" > "abd"
false

julia> 5 > 3
true
```
