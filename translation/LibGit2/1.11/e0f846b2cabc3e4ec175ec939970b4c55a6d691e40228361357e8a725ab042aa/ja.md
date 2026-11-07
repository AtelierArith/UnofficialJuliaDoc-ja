```julia
LibGit2.format(result::GitDescribeResult; kwarg...)::String
```

`GitDescribeResult` に基づいて、書式付き文字列を生成します。書式オプションは、次のキーワード引数で指定します。

  * `options::DescribeFormatOptions=DescribeFormatOptions()`
