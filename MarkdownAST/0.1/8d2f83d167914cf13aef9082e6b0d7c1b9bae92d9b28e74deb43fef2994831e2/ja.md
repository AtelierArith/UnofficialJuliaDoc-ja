```
length(node.children::NodeChildren) -> Int
```

`node :: Node`の子の数を返します。

子はリンクリストとして保存されているため、このメソッドはO(n)の複雑さを持ちます。そのため、子が存在するかどうかを確認するには、一般的に[`isempty`](@ref Base.isempty(::NodeChildren))を使用する方が望ましいです。
