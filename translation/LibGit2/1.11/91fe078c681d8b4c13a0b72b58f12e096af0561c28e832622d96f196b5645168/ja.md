```julia
(::Type{T})(te::GitTreeEntry) where T<:GitObject
```

`te` が参照する Git オブジェクトを取得し、実際の型（[`entrytype`](@ref) に表示される型）で返します。たとえば、`GitBlob` や `GitTag` です。

# Examples

```julia
tree = LibGit2.GitTree(repo, "HEAD^{tree}")
tree_entry = tree[1]
blob = LibGit2.GitBlob(tree_entry)
```
