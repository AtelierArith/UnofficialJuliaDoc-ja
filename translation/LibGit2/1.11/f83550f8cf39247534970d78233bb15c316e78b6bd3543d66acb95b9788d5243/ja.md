```julia
push(repo::GitRepo; kwargs...)
```

`repo` のアップストリームに更新をプッシュします。

キーワード引数は次のとおりです。

  * `remote::AbstractString="origin"`: プッシュ先のアップストリームリモートの名前。
  * `remoteurl::AbstractString=""`: `remote` の URL。
  * `refspecs=AbstractString[]`: プッシュのプロパティを指定します。
  * `force::Bool=false`: 強制プッシュを行い、リモートブランチを上書きするかどうかを指定します。
  * `credentials=nothing`: プライベートな `remote` に対する認証時に、認証情報や設定を指定します。
  * `callbacks=Callbacks()`: ユーザーが指定するコールバックとペイロード。

`git push [<remoteurl>|<repo>] [<refspecs>]` と同等です。
