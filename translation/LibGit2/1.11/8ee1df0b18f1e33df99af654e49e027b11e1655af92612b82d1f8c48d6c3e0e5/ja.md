```julia
merge_base(repo::GitRepo, one::AbstractString, two::AbstractString) -> GitHash
```

コミット `one` と `two` の間のマージベース（共通の祖先）を見つけます。`one` と `two` はどちらも文字列形式である可能性があります。マージベースの `GitHash` を返します。
