```
LibGit2.push_head!(w::GitRevWalker)
```

Push the HEAD commit and its ancestors onto the [`GitRevWalker`](@ref) `w`. This ensures that HEAD and all its ancestor commits will be encountered during the walk.
