```
(::Type{T})(te::GitTreeEntry) where T<:GitObject
```

`te` が参照する git オブジェクトを取得し、それを実際の型（[`entrytype`](@ref) が示す型）として返します。例えば、`GitBlob` や `GitTag` などです。

# 例

```julia
tree = LibGit2.GitTree(repo, "HEAD^{tree}")
tree_entry = tree[1]
blob = LibGit2.GitBlob(tree_entry)
```
