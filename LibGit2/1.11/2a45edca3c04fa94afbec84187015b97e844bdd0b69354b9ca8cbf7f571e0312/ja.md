```
LibGit2.DescribeOptions
```

[`git_describe_options`](https://libgit2.org/libgit2/#HEAD/type/git_describe_options) 構造体に対応しています。

フィールドは次のように表します：

  * `version`: 使用中の構造体のバージョン。将来的に変更される場合に備えています。現時点では常に `1` です。
  * `max_candidates_tags`: コミットを説明するために `refs/tags` にある最近のタグをこの数だけ考慮します。デフォルトは 10 です（つまり、10 個の最も最近のタグがコミットを説明するかどうかを調べます）。
  * `describe_strategy`: `refs/tags` のすべてのエントリを考慮するか（`git-describe --tags` に相当）、または `refs/` のすべてのエントリを考慮するか（`git-describe --all` に相当）を指定します。デフォルトは注釈付きタグのみを表示します。`Consts.DESCRIBE_TAGS` が渡されると、注釈の有無にかかわらずすべてのタグが考慮されます。`Consts.DESCRIBE_ALL` が渡されると、`refs/` 内の任意の参照が考慮されます。
  * `pattern`: `pattern` に一致するタグのみを考慮します。グロブ展開をサポートしています。
  * `only_follow_first_parent`: 一致する参照から説明されたオブジェクトまでの距離を見つける際に、最初の親からの距離のみを考慮します。
  * `show_commit_oid_as_fallback`: コミットを説明する一致する参照が見つからない場合、エラーをスローする代わりにコミットの [`GitHash`](@ref) を表示します（デフォルトの動作）。
