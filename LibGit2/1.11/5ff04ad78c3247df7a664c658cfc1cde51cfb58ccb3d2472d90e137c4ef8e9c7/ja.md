```julia
committer(c::GitCommit)
```

コミット `c` のコミッターの `Signature` を返します。コミッターは、元々 [`author`](@ref) によって作成された変更をコミットした人ですが、`author` と同じである必要はありません。たとえば、`author` がパッチを `committer` にメールで送信し、`committer` がそれをコミットした場合などです。
