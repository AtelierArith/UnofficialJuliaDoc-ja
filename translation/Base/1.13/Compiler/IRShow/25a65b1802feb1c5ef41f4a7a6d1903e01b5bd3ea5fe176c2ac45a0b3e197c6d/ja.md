```julia
Compute line number annotations for an IRCode or CodeInfo.
```

この関数は、IR の各行について 3 つの注釈を計算します。次の例を見てみましょう（`@code_typed sin(1.0)` から引用）。

```julia
    **                                                    ***         **********
    35 6 ── %10  = :(Base.mul_float)(%%2, %%2)::Float64   │╻╷         sin_kernel
       │    %11  = :(Base.mul_float)(%10, %10)::Float64   ││╻          *
```

3 つの注釈は `*` で示されています。1 つ目は、現在の関数の行番号です（最も外側の行番号が変わるたびに 1 回だけ出力されます）。2 つ目はインライン化を示す印です。行数はネストの深さを表し、半分の長さの線（╷）はスコープの開始を、通常の長さの線（│）はスコープが続いていることを示します。最後の注釈は最も複雑なもので、入ったスコープの名前をヒューリスティックに出力します。ここでは、まだ出力されていないスコープのうち、最も外側のものを出力しようとします。影響とトレードオフを確認するため、いくつか例を見ていきましょう。

```julia
f() = leaf_function() # Deliberately not defined to end up in the IR verbatim
g() = f()
h() = g()
top_function() = h()
```

インライン化すると、次のようになります。

```julia
1 1 ─ %1 = :(Main.leaf_function)()::Any   │╻╷╷ h
  └──      return %1                      │
```

出力される関数は最も外側の関数だけです。確かに情報は失われますが、最も外側の関数が（対象の関数という文脈では）最も意味を持つと考えられるため、このようにしています。

一方、f を再定義するとどうなるか見てみましょう。

```julia
function f()
    leaf_function()
    leaf_function()
    leaf_function()
end
```

次のようになります。

```julia
1 1 ─      :(Main.leaf_function)()::Any   │╻╷╷ h
  │        :(Main.leaf_function)()::Any   ││┃│  g
  │   %3 = :(Main.leaf_function)()::Any   │││┃   f
  └──      return %3                      │
```

最初の文から `f` スコープ内にいたにもかかわらず、中間のスコープが出力されるまでに 2 つの文が必要でした。どのスコープが出力されているかは、メソッド名のインデントと、そのスコープに対応する線が太くなっていることの両方で示されます。
