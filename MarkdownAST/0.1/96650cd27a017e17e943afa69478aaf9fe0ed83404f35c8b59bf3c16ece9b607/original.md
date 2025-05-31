```
replace(f::Function, root::Node) -> Node
```

Creates a copy of the tree where all child nodes of `root` are recursively (post-order depth-first) replaced by the result of `f(child)`.

The function `f(child::Node)` must return either a new [`Node`](@ref) to replace `child` or a Vector of nodes that will be inserted as siblings, replacing `child`.

Note that `replace` does not allow the construction of invalid trees, and element replacements that require invalid parent-child relationships (e.g., a block element as a child to an element expecting inlines) will throw an error.

# Example

The following snippet removes links from the given AST. That is, it replaces [`Link`](@ref) nodes with their link text (which may contain nested inline markdown elements):

```julia
new_mdast = replace(mdast) do node
    if node.element isa MarkdownAST.Link
        return [MarkdownAST.copy_tree(child) for child in node.children]
    else
        return node
    end
end
```
