```
restore(s::State, repo::GitRepo)
```

リポジトリ `repo` を以前の `State` `s` に戻します。例えば、マージ試行の前のブランチの HEAD です。`s` は [`snapshot`](@ref) 関数を使用して生成できます。
