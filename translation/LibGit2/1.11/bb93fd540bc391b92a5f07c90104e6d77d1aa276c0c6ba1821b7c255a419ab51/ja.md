```julia
LibGit2.GitDescribeResult(committish::GitObject; kwarg...)
```

キーワード引数に基づいて、対象の詳細情報を含む`GitDescribeResult`を`committish` `GitObject`から生成します。

  * `options::DescribeOptions=DescribeOptions()`

`committish`オブジェクトのgit descriptionでは、`committish`から到達可能なタグのうち、最も新しいものを探します（デフォルトでは注釈付きタグが対象ですが、すべてのタグを検索することもできます）。タグが`committish`を指している場合、descriptionにはタグのみが含まれます。それ以外の場合は、`committish`から最新のタグまでのコミット数を含むサフィックスが追加されます。該当するタグがない場合、デフォルトではdescriptionの生成に失敗しますが、`options`で動作を変更できます。

`git describe <committish>`と同等です。詳しくは[`DescribeOptions`](@ref)を参照してください。
