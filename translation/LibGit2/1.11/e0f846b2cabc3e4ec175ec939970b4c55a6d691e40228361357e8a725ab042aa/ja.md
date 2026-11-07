```julia
LibGit2.format(result::GitDescribeResult; kwarg...)::String
```

`GitDescribeResult` に基づいて、書式設定された文字列を生成します。書式設定オプションは、次のキーワード引数で制御します。

  * `options::DescribeFormatOptions=DescribeFormatOptions()`
