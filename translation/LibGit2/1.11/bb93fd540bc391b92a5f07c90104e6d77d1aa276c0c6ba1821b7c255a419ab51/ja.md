```julia
LibGit2.GitDescribeResult(committish::GitObject; kwarg...)
```

キーワード引数に基づいて、`committish` `GitObject` に関する詳細情報を含む `GitDescribeResult` を生成します。

  * `options::DescribeOptions=DescribeOptions()`

`committish` オブジェクトの git 記述では、`committish` から到達可能な最新のタグを検索します（デフォルトでは注釈付きタグが対象ですが、すべてのタグを検索することもできます）。そのタグが `committish` を指している場合、記述にはタグのみが含まれます。そうでない場合は、`committish` と最新のタグの間にあるコミット数を含む接尾辞が付加されます。該当するタグがない場合、デフォルトでは記述の生成に失敗しますが、この動作は `options` で変更できます。

`git describe <committish>` と同等です。詳細は [`DescribeOptions`](@ref) を参照してください。
