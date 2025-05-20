```
fetch(repo::GitRepo; kwargs...)
```

リポジトリ `repo` のアップストリームから更新を取得します。

キーワード引数は次のとおりです：

  * `remote::AbstractString="origin"`: `repo` から取得するリモートの名前。これが空の場合、URLを使用して匿名リモートを構築します。
  * `remoteurl::AbstractString=""`: `remote` のURL。指定されていない場合、`remote` の名前に基づいて仮定されます。
  * `refspecs=AbstractString[]`: フェッチのプロパティを決定します。
  * `credentials=nothing`: プライベート `remote` に対して認証する際に、資格情報および/または設定を提供します。
  * `callbacks=Callbacks()`: ユーザー提供のコールバックおよびペイロード。

`git fetch [<remoteurl>|<repo>] [<refspecs>]` と同等です。
