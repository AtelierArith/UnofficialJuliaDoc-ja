```julia
committer(c::GitCommit)
```

`c` のコミットのコミッターの `Signature` を返します。コミッターとは、[`author`](@ref) が最初に作成した変更をコミットした人です。たとえば、`author` がパッチをメールで `committer` に送り、その人がコミットした場合など、コミッターは `author` と同一人物とは限りません。
