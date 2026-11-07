```julia
LibGit2.DescribeOptions
```

[`git_describe_options`](https://libgit2.org/libgit2/#HEAD/type/git_describe_options) 構造体に一致します。

各フィールドの意味は次のとおりです。

  * `version`: 後で構造体のバージョンが変更された場合に備えて、使用中の構造体のバージョンを示します。現時点では、常に `1` です。
  * `max_candidates_tags`: コミットを説明するタグを探すため、`refs/tags` 内の最新のタグをこの数だけ調べます。デフォルトは 10 です（つまり、コミットを説明するタグがあるかどうかを確認するため、最新の 10 個のタグを調べます）。
  * `describe_strategy`: `refs/tags`（`git-describe --tags` と同等）のすべてのエントリを対象にするか、`refs/`（`git-describe --all` と同等）のすべてのエントリを対象にするかを指定します。デフォルトでは、注釈付きタグのみが表示されます。`Consts.DESCRIBE_TAGS` を渡すと、注釈付きかどうかを問わず、すべてのタグが対象になります。`Consts.DESCRIBE_ALL` を渡すと、`refs/` 内のすべての参照が対象になります。
  * `pattern`: `pattern` に一致するタグのみを対象にします。glob 展開に対応しています。
  * `only_follow_first_parent`: 一致する参照から説明対象のオブジェクトまでの距離を求める際、最初の親からの距離のみを対象にします。
  * `show_commit_oid_as_fallback`: コミットを説明する一致する参照が見つからない場合、エラーをスローせず、コミットの [`GitHash`](@ref) を表示します（これがデフォルトの動作です）。
