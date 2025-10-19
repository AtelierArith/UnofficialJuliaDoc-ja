```julia
LibGit2.RebaseOperation
```

リベース中に実行される単一の命令/操作を説明します。 [`git_rebase_operation`](https://libgit2.org/libgit2/#HEAD/type/git_rebase_operation_t) 構造体に対応しています。

フィールドは次のことを表します：

  * `optype`: 現在実行中のリベース操作のタイプ。オプションは次のとおりです：

      * `REBASE_OPERATION_PICK`: 問題のコミットをチェリーピックします。
      * `REBASE_OPERATION_REWORD`: 問題のコミットをチェリーピックしますが、そのメッセージをプロンプトを使用して書き換えます。
      * `REBASE_OPERATION_EDIT`: 問題のコミットをチェリーピックしますが、ユーザーがコミットの内容とそのメッセージを編集できるようにします。
      * `REBASE_OPERATION_SQUASH`: 問題のコミットを前のコミットにスクワッシュします。2つのコミットのコミットメッセージはマージされます。
      * `REBASE_OPERATION_FIXUP`: 問題のコミットを前のコミットにスクワッシュします。前のコミットのコミットメッセージのみが使用されます。
      * `REBASE_OPERATION_EXEC`: コミットをチェリーピックしません。コマンドを実行し、コマンドが正常に終了した場合は続行します。
  * `id`: このリベースステップで作業中のコミットの [`GitHash`](@ref)。
  * `exec`: `REBASE_OPERATION_EXEC` が使用される場合、このステップで実行するコマンド（たとえば、各コミットの後にテストスイートを実行すること）。
