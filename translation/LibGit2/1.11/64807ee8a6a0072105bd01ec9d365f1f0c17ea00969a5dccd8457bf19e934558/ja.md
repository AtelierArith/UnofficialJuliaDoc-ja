```julia
LibGit2.DescribeFormatOptions
```

[`git_describe_format_options`](https://libgit2.org/libgit2/#HEAD/type/git_describe_format_options) 構造体に対応します。

各フィールドの意味は次のとおりです。

  * `version`: 後で変更される場合に備えた、使用中の構造体のバージョン。現時点では、常に `1` です。
  * `abbreviated_size`: 省略形の `GitHash` のサイズの下限。既定値は `7` です。
  * `always_use_long_format`: `1` に設定すると、短い形式を使用できる場合でも、文字列に長い形式を使用します。
  * `dirty_suffix`: 設定されている場合、[`workdir`](@ref) が dirty のとき、説明文字列の末尾に追加されます。
