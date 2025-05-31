```
Base.pushfirst!(node.children::NodeChildren, child::Node) -> NodeChildren
```

Adds `child` as the first child node of `node :: Node`. If `child` is part of another tree, then it is unlinked from that tree first (see [`unlink!`](@ref)). Returns the iterator over children.
