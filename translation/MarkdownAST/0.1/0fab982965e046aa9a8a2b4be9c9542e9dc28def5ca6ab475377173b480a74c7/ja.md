```julia
Base.push!(node.children::NodeChildren, child::Node) -> NodeChildren
```

`child`を`node :: Node`の最後の子ノードとして追加します。`child`が別の木の一部である場合、最初にその木からリンク解除されます（[`unlink!`](@ref]を参照）。子ノードのイテレータを返します。
