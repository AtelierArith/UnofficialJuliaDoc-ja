```
Base.pushfirst!(node.children::NodeChildren, child::Node) -> NodeChildren
```

`child`を`node :: Node`の最初の子ノードとして追加します。`child`が別のツリーの一部である場合、最初にそのツリーからリンク解除されます（[`unlink!`](@ref]を参照）。子ノードのイテレータを返します。
