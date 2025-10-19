```julia
eltype(node.children::NodeChildren) = Node{M}
```

ツリーの正確な `Node` 型を返し、`.children` イテレータの要素の型に対応します。
