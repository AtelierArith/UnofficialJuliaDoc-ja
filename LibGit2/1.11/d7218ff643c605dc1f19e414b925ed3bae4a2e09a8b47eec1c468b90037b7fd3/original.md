```julia
getindex(tree::GitTree, target::AbstractString) -> GitObject
```

Look up `target` path in the `tree`, returning a [`GitObject`](@ref) (a [`GitBlob`](@ref) in the case of a file, or another [`GitTree`](@ref) if looking up a directory).

# Examples

```julia
tree = LibGit2.GitTree(repo, "HEAD^{tree}")
readme = tree["README.md"]
subtree = tree["test"]
runtests = subtree["runtests.jl"]
```
