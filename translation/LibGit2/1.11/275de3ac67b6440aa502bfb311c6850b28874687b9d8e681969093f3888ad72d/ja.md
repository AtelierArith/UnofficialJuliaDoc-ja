```
LibGit2.push_head!(w::GitRevWalker)
```

HEAD コミットとその祖先を [`GitRevWalker`](@ref) `w` にプッシュします。これにより、HEAD とそのすべての祖先コミットがウォーク中に遭遇することが保証されます。
