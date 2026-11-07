```julia
Compute line number annotations for an IRCode or CodeInfo.
```

この関数は、IRの各行について3種類の注釈を計算します。次の例を見てみましょう（`@code_typed sin(1.0)`から引用）。

```julia
    **                                                    ***         **********
    35 6 ── %10  = :(Base.mul_float)(%%2, %%2)::Float64   │╻╷         sin_kernel
       │    %11  = :(Base.mul_float)(%10, %10)::Float64   ││╻          *
```

3種類の注釈は`*`で示されています。1つ目は、現在の関数の行番号です（最も外側の行番号が変わるたびに1回だけ表示されます）。2つ目はインライン化を示す印です。線の本数はネストの深さを表し、半分の長さの線（╷）はスコープの開始、通常の長さの線（│）はスコープが継続していることを示します。最後の注釈は最も複雑で、入ったスコープの名前をヒューリスティックに表示します。ここでは、まだ表示されていないスコープのうち、最も外側のものを表示しようとします。どのような影響やトレードオフがあるのか、いくつか例を見ていきましょう。

```julia
f() = leaf_function() # Deliberately not defined to end up in the IR verbatim
g() = f()
h() = g()
top_function() = h()
```

インライン化後は、次のようになります。

```julia
1 1 ─ %1 = :(Main.leaf_function)()::Any   │╻╷╷ h
  └──      return %1                      │
```

表示される関数は最も外側の関数だけです。確かに情報は失われますが、最も外側の関数が（対象の関数という文脈では）最も意味のある情報を持つ、という考え方です。

一方、fを再定義するとどうなるか見てみましょう。

```julia
function f()
    leaf_function()
    leaf_function()
    leaf_function()
end
```

結果は次のとおりです。

```julia
1 1 ─      :(Main.leaf_function)()::Any   │╻╷╷ h
  │        :(Main.leaf_function)()::Any   ││┃│  g
  │   %3 = :(Main.leaf_function)()::Any   │││┃   f
  └──      return %3                      │
```

最初の文から`f`スコープ内にいたにもかかわらず、中間のスコープが表示されるまでに2つの文が必要でした。どのスコープが表示されているかは、メソッド名のインデントと、そのスコープに対応する線が太くなっていることで示されます。
