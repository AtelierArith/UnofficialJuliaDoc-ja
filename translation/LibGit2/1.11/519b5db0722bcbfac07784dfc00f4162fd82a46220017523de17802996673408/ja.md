```
getindex(tree::GitTree, target::AbstractString) -> GitObject
```

`tree`内の`target`パスを検索し、[`GitObject`](@ref)（ファイルの場合は[`GitBlob`](@ref）、ディレクトリを検索している場合は別の[`GitTree`](@ref)）を返します。

# 例

```julia
tree = LibGit2.GitTree(repo, "HEAD^{tree}")
readme = tree["README.md"]
subtree = tree["test"]
runtests = subtree["runtests.jl"]
```
