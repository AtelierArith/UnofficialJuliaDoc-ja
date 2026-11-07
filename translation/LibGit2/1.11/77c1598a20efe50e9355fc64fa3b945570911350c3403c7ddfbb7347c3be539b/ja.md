```julia
LibGit2.GitDescribeResult(repo::GitRepo; kwarg...)
```

リポジトリ `repo` の作業ディレクトリを表す `GitDescribeResult` を生成します。`GitDescribeResult` には、次のキーワード引数に基づく作業ディレクトリの詳細情報が含まれます。

  * `options::DescribeOptions=DescribeOptions()`

この場合、HEAD を基準に説明を生成し、HEAD の祖先である最新のタグを取得します。その後、[`workdir`](@ref) の状態を確認し、`workdir` が汚れている場合（[`isdirty`](@ref) を参照）、説明も汚れているものとして扱います。

`git describe` と同等です。詳しくは [`DescribeOptions`](@ref) を参照してください。
