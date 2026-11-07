```julia
isless(x, y)
```

`x` が `y` より小さいかどうかを、（[`isequal`](@ref) とともに定義される）固定された全順序に従って判定します。`isless` は、すべての型の `(x, y)` の組に対して定義されているわけではありません。ただし、定義されている場合は、次の性質を満たすことが期待されます。

  * `isless(x, y)` が定義されているなら、`isless(y, x)` と `isequal(x, y)` も定義され、その3つのうちちょうど1つだけが `true` となります。
  * `isless` が定める関係は推移的です。つまり、`isless(x, y) && isless(y, z)` ならば `isless(x, z)` です。

通常は順序付けられない値（`NaN` など）は、通常の値より後に順序付けられます。[`missing`](@ref) の値は最後に順序付けられます。

これは、[`sort!`](@ref) が使用するデフォルトの比較です。

# Implementation

全順序を持つ非数値型では、この関数を実装する必要があります。数値型では、`NaN` のような特殊値を持つ場合にのみ実装が必要です。半順序を持つ型では、[`<`](@ref) を実装してください。ソートや関連する関数で使用できる別の順序付け方法の定義については、[Alternate Orderings](@ref) のドキュメントを参照してください。

# Examples

```jldoctest
julia> isless(1, 3)
true

julia> isless("Red", "Blue")
false
```
