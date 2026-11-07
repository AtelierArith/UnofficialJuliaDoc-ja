```julia
LibGit2.GitDescribeResult(repo::GitRepo; kwarg...)
```

リポジトリ `repo` の作業ディレクトリについて、`GitDescribeResult` を生成します。`GitDescribeResult` には、次のキーワード引数に基づく作業ディレクトリの詳細情報が含まれます。

  * `options::DescribeOptions=DescribeOptions()`

この場合、HEAD に対して説明を実行し、HEAD の祖先である最新のタグを生成します。その後、[`workdir`](@ref) のステータスを確認し、`workdir` がダーティ（[`isdirty`](@ref) を参照）であれば、説明もダーティとみなされます。

`git describe` と同等です。詳しくは [`DescribeOptions`](@ref) を参照してください。
