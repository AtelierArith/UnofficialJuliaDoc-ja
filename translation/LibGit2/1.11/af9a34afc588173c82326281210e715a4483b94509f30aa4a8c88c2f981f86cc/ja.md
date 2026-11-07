```julia
credential_callback(...)::Cint
```

接続プロトコルに応じて異なる認証情報の取得方法を提供する、LibGit2 の認証情報コールバック関数です。`payload_ptr` には、状態と設定を管理する `LibGit2.CredentialPayload` オブジェクトを格納する必要があります。

`allowed_types` には、試行する認証方式を指定する `LibGit2.Consts.GIT_CREDTYPE` 値のビットマスクが格納されます。

認証情報による認証は、対応している場合、次の順序で行われます。

  * SSH エージェント
  * SSH 秘密鍵／公開鍵のペア
  * ユーザー名とパスワード（平文）

認証情報の入力を求められた場合、`^D` と入力すると、プロンプトを中断できます（control キーを押しながら `d` キーを押します）。

**注**: `libgit2` 認証の仕様上、認証に失敗しても、成功したかどうかを示す情報なしにこの関数が再度呼び出されます。同じ無効な認証情報を繰り返し使用して無限ループに陥るのを防ぐため、ペイロードを使って状態を管理します。

詳しくは、LibGit2 の [authenticating against a server](https://libgit2.org/docs/guides/authentication/) に関するガイドを参照してください。
