```julia
isshallow(repo::GitRepo)::Bool
```

Determine if `repo` is a shallow clone. A shallow clone has a truncated history, created by cloning with a specific depth (e.g., `LibGit2.clone(url, path, depth=1)`).

# Examples

```julia
shallow_repo = LibGit2.clone(url, "shallow_path", depth=1)
LibGit2.isshallow(shallow_repo)  # returns true

normal_repo = LibGit2.clone(url, "normal_path")
LibGit2.isshallow(normal_repo)  # returns false
```
