```julia
LibGit2.commit(rb::GitRebase, sig::GitSignature)
```

現在のパッチをリベース `rb` にコミットし、コミッターには `sig` を指定してください。コミットがすでに適用されている場合は、何も出力しないでください。
