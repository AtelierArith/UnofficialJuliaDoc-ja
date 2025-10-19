```julia
prepend!(node.children::NodeChildren, children) -> NodeChildren
```

Adds all the elements of the iterable `children` to the beginning of the list of children of `node`. If any of `children` are part of another tree, then they are unlinked from that tree first (see [`unlink!`](@ref)). Returns the iterator over children.

!!! warning "Error during a prepend"
    The operation is not atomic, and an error during a `prepend!` (e.g. due to an element of the wrong type in `children`) can result in a partial prepend of the new children, similar to how `append!` behaves with arrays (see [JuliaLang/julia#15868](https://github.com/JuliaLang/julia/issues/15868)).

