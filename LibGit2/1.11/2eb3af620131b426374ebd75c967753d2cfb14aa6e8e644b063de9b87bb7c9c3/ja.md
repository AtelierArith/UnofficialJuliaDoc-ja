```julia
committer(c::GitCommit)
```

`c` のコミットのコミッターの `Signature` を返します。コミッターとは、[`author`](@ref) が元々作成した変更をコミットした人です。ただし、コミッターは `author` と同一人物とは限りません。たとえば、`author` がパッチをメールで `committer` に送り、その人がコミットした場合が該当します。
