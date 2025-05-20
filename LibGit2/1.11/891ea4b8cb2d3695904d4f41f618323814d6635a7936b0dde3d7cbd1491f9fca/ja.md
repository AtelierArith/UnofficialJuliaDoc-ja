```
LibGit2.GitDescribeResult(repo::GitRepo; kwarg...)
```

リポジトリ `repo` の作業ディレクトリの `GitDescribeResult` を生成します。`GitDescribeResult` には、キーワード引数に基づいた作業ディレクトリに関する詳細情報が含まれています：

  * `options::DescribeOptions=DescribeOptions()`

この場合、説明は HEAD で実行され、HEAD の祖先である最も最近のタグが生成されます。その後、[`workdir`](@ref) に対してステータスチェックが行われ、`workdir` が汚れている場合（[`isdirty`](@ref) を参照）には、説明も汚れていると見なされます。

`git describe` と同等です。詳細については [`DescribeOptions`](@ref) を参照してください。
