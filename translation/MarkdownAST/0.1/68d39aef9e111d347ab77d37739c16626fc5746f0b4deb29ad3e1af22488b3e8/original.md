```
==(x::Node, y::Node) -> Bool
```

Determines if two trees are equal by recursively walking through the whole tree (if need be) and comparing each node. Parent nodes are ignored when comparing for equality (so that it would be possible to compare subtrees). If the metadata type does not match, the two trees are not considered equal.
