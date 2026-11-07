# Git workflow recommendations

## Git Recommendations For Pull Requests

  * フォークの`master`ブランチで作業するのは避けてください。新しいブランチを作成しておくと、Juliaの`master`が変更されたときに、プルリクエストを更新しやすくなります。
  * 同じコード箇所に繰り返し変更を加える場合は、それらを小さなコミットにまとめるようにしてください。プルリクエストをレビューしやすくなります。変更が大きい場合は特に、適切に分割された複数のコミットにするのがよいでしょう。[squash](https://gitready.com/advanced/2009/02/10/squashing-commits-with-rebase.html)
  * Juliaの`master`への変更によって競合が発生した場合は、`git merge`や`git pull`ではなく、`git rebase`を使ってプルリクエストのブランチを更新してください。後者ではマージコミットが作成され、Gitの履歴が不要に煩雑になり、変更のレビューが難しくなるためです。
  * 説明的なコミットメッセージを付けるとよいでしょう。
  * 意図しない変更をコミットしてしまうのを防ぐには、`git add -p`や`git add -i`が役立ちます。
  * Issueやプルリクエストの議論で特定のコード行へのリンクを貼るときは、GitHubでコードを表示した状態で`y`キーを押してください。表示中のバージョンを含むURLでページが再読み込みされます。そうすれば、ファイルの内容が変わった後も、参照したコード行が分かるようになります。
  * 既存のコミットから空白文字を自動的に削除できます。`git rebase`

      * 直前のコミットから空白文字を削除するには、`git rebase --whitespace=fix HEAD~1`を実行します。
      * `master`ブランチとの差分から空白文字を削除するには、`git rebase --whitespace=fix master`を実行します。

### Git Recommendations For Pull Request Reviewers

  * マージには、通常`squash+merge`を使います。個々のコミットを履歴に残したい、慎重に段階分けされたコミットを含むプルリクエストというまれなケースでは`merge`も使えますが、通常は`squash+merge`を優先してください。
