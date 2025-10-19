```julia
LibGit2.DescribeFormatOptions
```

[`git_describe_format_options`](https://libgit2.org/libgit2/#HEAD/type/git_describe_format_options) 構造体に対応しています。

フィールドは次のことを表します：

  * `version`: 使用中の構造体のバージョン。将来的に変更される場合に備えています。現在は常に `1` です。
  * `abbreviated_size`: 使用する省略された `GitHash` のサイズの下限で、デフォルトは `7` です。
  * `always_use_long_format`: 短い形式が使用できる場合でも、文字列に長い形式を使用するために `1` に設定します。
  * `dirty_suffix`: 設定されている場合、[`workdir`](@ref) が汚れているときに説明文字列の末尾に追加されます。
