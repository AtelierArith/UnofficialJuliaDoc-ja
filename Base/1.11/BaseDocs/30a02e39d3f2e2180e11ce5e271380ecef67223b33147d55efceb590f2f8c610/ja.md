```
a ? b : c
```

条件の短縮形; 「`a` が真なら `b` を評価し、そうでなければ `c` を評価する」と読みます。別名 [三項演算子](https://en.wikipedia.org/wiki/%3F:).

この構文は `if a; b else c end` と同等ですが、`b` または `c` の値が大きな式の一部として使用されることを強調するためにしばしば使用されます。`b` または `c` を評価することによる副作用よりも。

詳細については、[制御フロー](@ref man-conditional-evaluation) のマニュアルセクションを参照してください。

# 例

```jldoctest
julia> x = 1; y = 2;

julia> x > y ? println("x is larger") : println("x is not larger")
x is not larger

julia> x > y ? "x is larger" : x == y ? "x and y are equal" : "y is larger"
"y is larger"
```
