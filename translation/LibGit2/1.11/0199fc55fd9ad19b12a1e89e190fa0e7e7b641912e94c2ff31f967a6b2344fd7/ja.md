```
LibGit2.BlameHunk
```

[`git_blame_hunk`](https://libgit2.org/libgit2/#HEAD/type/git_blame_hunk) 構造体に対応しています。フィールドは次のことを表します：     * `lines_in_hunk`: このブレームのハンク内の行数。     * `final_commit_id`: このセクションが最後に変更されたコミットの [`GitHash`](@ref)。     * `final_start_line_number`: ファイル内のハンクが開始する*1ベース*の行番号、ファイルの*最終*バージョンにおける。     * `final_signature`: このハンクを最後に修正した人の署名。これを `Signature` に渡してそのフィールドにアクセスする必要があります。     * `orig_commit_id`: このハンクが最初に見つかったコミットの [`GitHash`](@ref)。     * `orig_path`: ハンクが発生したファイルへのパス。これは現在の/最終的なパスとは異なる場合があります。たとえば、ファイルが移動された場合などです。     * `orig_start_line_number`: `orig_path` の*元の*バージョンのファイル内でハンクが開始する*1ベース*の行番号。     * `orig_signature`: このハンクを導入した人の署名。これを `Signature` に渡してそのフィールドにアクセスする必要があります。     * `boundary`: 元のコミットが「境界」コミットである場合は `'1'`（たとえば、`options` に設定された最も古いコミットと等しい場合）。
