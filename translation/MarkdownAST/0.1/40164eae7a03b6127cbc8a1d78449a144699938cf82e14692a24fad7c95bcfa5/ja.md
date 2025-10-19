```julia
length(node.children::NodeChildren) -> Int
```

`node :: Node`の子供の数を返します。

子供はリンクリストとして保存されているため、このメソッドはO(n)の複雑さを持ちます。そのため、子供が全く存在するかどうかを確認するには、一般的に[`isempty`](@ref Base.isempty(::NodeChildren))を使用する方が望ましいです。
