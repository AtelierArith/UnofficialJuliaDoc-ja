```
LibGit2.GitDescribeResult(committish::GitObject; kwarg...)
```

`committish` `GitObject`の`GitDescribeResult`を生成します。これはキーワード引数に基づいて詳細情報を含みます：

  * `options::DescribeOptions=DescribeOptions()`

`committish`オブジェクトのgit説明は、`committish`から到達可能な最も最近のタグ（デフォルトでは注釈付きですが、すべてのタグを検索することもできます）を探します。タグが`committish`を指している場合、説明にはタグのみが含まれます。それ以外の場合、`committish`と最も最近のタグの間のコミット数を含むサフィックスが含まれます。そのようなタグが存在しない場合、デフォルトの動作は説明が失敗することですが、これは`options`を通じて変更できます。

`git describe <committish>`に相当します。詳細については[`DescribeOptions`](@ref)を参照してください。
