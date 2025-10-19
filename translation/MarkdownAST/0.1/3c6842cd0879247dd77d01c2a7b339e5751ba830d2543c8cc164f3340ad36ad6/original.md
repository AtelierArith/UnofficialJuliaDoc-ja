```julia
eltype(node.children::NodeChildren) = Node{M}
```

Returns the exact `Node` type of the tree, corresponding to the type of the elements of the `.children` iterator.
