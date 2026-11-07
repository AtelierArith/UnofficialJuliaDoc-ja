```julia
getindex(tree::GitTree, target::AbstractString)::GitObject
```

`target` path を `tree` 内で検索し、[`GitObject`](@ref) を返します（ファイルの場合は [`GitBlob`](@ref)、ディレクトリを検索する場合は別の [`GitTree`](@ref) を返します）。

# Examples

```julia
tree = LibGit2.GitTree(repo, "HEAD^{tree}")
readme = tree["README.md"]
subtree = tree["test"]
runtests = subtree["runtests.jl"]
```
