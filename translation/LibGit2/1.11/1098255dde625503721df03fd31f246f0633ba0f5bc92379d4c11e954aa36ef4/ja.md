```julia
LibGit2.push_head!(w::GitRevWalker)
```

HEAD コミットとその祖先を [`GitRevWalker`](@ref) `w` にプッシュします。これにより、ウォーク中に HEAD とそのすべての祖先コミットが検出されるようになります。
