```
LibGit2.format(result::GitDescribeResult; kwarg...) -> String
```

`GitDescribeResult`に基づいてフォーマットされた文字列を生成します。フォーマットオプションはキーワード引数によって制御されます：

  * `options::DescribeFormatOptions=DescribeFormatOptions()`
