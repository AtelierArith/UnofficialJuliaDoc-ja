```julia
merge_base(repo::GitRepo, one::AbstractString, two::AbstractString)::GitHash
```

コミット `one` と `two` の間で、マージベース（共通の祖先）を見つけてください。`one` と `two` は、どちらも文字列形式の場合があります。マージベースの `GitHash` を返してください。
