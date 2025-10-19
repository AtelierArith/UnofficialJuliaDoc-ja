```julia
length(node.children::NodeChildren) -> Int
```

Returns the number of children of `node :: Node`.

As the children are stored as a linked list, this method has O(n) complexity. As such, to check there are any children at all, it is generally preferable to use [`isempty`](@ref Base.isempty(::NodeChildren)).
