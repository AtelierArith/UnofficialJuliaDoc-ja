# Git workflow recommendations

## Git Recommendations For Pull Requests

  * フォークの `master` ブランチを使って作業するのは避けてください。新しいブランチを作成しておくと、Julia の `master` が変更されたときにプルリクエストを更新しやすくなります。
  * 同じコード箇所に繰り返し変更を加える場合は、小さなコミットをまとめるように [squash](https://gitready.com/advanced/2009/02/10/squashing-commits-with-rebase.html) してください。そうすると、プルリクエストをレビューしやすくなります。変更を適切に分割したコミットをいくつか作成するのは問題ありません。特に大きな変更では有効です。
  * Julia の `master` の変更によって競合が発生した場合は、`git merge` や `git pull` ではなく、`git rebase` を使ってプルリクエストのブランチを更新してください。後者はマージコミットを作成し、Git の履歴に不要なノイズが増えて変更のレビューが難しくなるためです。
  * 説明的なコミットメッセージを付けるとよいでしょう。
  * 意図しない変更をコミットしてしまうのを防ぐには、`git add -p` や `git add -i` が役立ちます。
  * Issue やプルリクエストの議論で特定のコード行へのリンクを貼る場合は、GitHub でコードを表示中に `y` キーを押してください。表示中のバージョンを含む URL でページが再読み込みされます。そうすれば、ファイルの内容が変わった後も、参照したコード行が分かるようになります。
  * 既存のコミットからは、空白文字を自動的に削除できます。`git rebase` を使ってください。

      * 直前のコミットから空白文字を削除するには、`git rebase --whitespace=fix HEAD~1` を実行します。
      * `master` ブランチとの差分から空白文字を削除するには、`git rebase --whitespace=fix master` を実行します。

### Git Recommendations For Pull Request Reviewers

  * マージする際は、通常 `squash+merge` を推奨します。個々のコミットを履歴に残したい、慎重に段階分けされたコミットを含む PR というまれなケースでは `merge` も許容されますが、通常は `squash+merge` を優先してください。
