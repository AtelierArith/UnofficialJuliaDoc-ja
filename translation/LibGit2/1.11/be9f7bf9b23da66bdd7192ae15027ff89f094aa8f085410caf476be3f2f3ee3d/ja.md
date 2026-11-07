```julia
LibGit2.RebaseOperation
```

リベース中に実行する単一の命令／操作を表します。[`git_rebase_operation`](https://libgit2.org/libgit2/#HEAD/type/git_rebase_operation_t) 構造体に対応します。

各フィールドの意味は次のとおりです。

  * `optype`: 現在実行中のリベース操作の種類。選択肢は次のとおりです。

      * `REBASE_OPERATION_PICK`: 対象のコミットを cherry-pick します。
      * `REBASE_OPERATION_REWORD`: 対象のコミットを cherry-pick し、プロンプトを使ってコミットメッセージを書き換えます。
      * `REBASE_OPERATION_EDIT`: 対象のコミットを cherry-pick し、コミットの内容とメッセージをユーザーが編集できるようにします。
      * `REBASE_OPERATION_SQUASH`: 対象のコミットを直前のコミットに squash します。2 つのコミットメッセージは統合されます。
      * `REBASE_OPERATION_FIXUP`: 対象のコミットを直前のコミットに squash します。直前のコミットメッセージのみが使用されます。
      * `REBASE_OPERATION_EXEC`: コミットを cherry-pick せず、コマンドを実行します。コマンドが正常終了した場合は続行します。
  * `id`: このリベース手順で処理するコミットの [`GitHash`](@ref)。
  * `exec`: `REBASE_OPERATION_EXEC` を使用する場合に、この手順で実行するコマンド（たとえば、各コミットの後にテストスイートを実行するコマンド）。
