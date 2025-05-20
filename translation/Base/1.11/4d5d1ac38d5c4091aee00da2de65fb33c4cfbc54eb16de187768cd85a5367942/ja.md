```
>(x, y)
```

大なり比較演算子。`y < x` にフォールバックします。

# 実装

一般的に、新しい型はこの関数の代わりに [`<`](@ref) を実装し、フォールバック定義 `>(x, y) = y < x` に依存すべきです。

# 例

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
