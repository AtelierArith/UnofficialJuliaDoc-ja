```julia
bcf = flatten(bc)
```

遅延ブロードキャスト演算の「フラット」な表現を作成します。f.(a, g.(b, c), d) から、それと等価な h.(a, b, c, d) を生成します。ここで、h(w, x, y, z) = f(w, g(x, y), z) です。内部表現では、Broadcasted(f, a, Broadcasted(g, b, c), d) が Broadcasted(h, a, b, c, d) になります。

これは任意の操作であり、場合によってはブロードキャストの独自実装を容易にできます。
