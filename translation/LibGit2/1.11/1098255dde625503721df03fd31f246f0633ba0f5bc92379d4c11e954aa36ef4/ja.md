```julia
LibGit2.push_head!(w::GitRevWalker)
```

HEAD コミットとその祖先を [`GitRevWalker`](@ref) `w` にプッシュします。これにより、ウォーク中に HEAD とその祖先のすべてのコミットが検出されるようになります。
