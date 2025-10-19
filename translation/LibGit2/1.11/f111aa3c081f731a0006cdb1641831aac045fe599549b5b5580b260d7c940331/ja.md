```julia
push(repo::GitRepo; kwargs...)
```

`repo`のアップストリームに更新をプッシュします。

キーワード引数は次の通りです：

  * `remote::AbstractString="origin"`: プッシュするアップストリームリモートの名前。
  * `remoteurl::AbstractString=""`: `remote`のURL。
  * `refspecs=AbstractString[]`: プッシュのプロパティを決定します。
  * `force::Bool=false`: プッシュが強制プッシュになるかどうかを決定し、リモートブランチを上書きします。
  * `credentials=nothing`: プライベート`remote`に対して認証する際の資格情報および/または設定を提供します。
  * `callbacks=Callbacks()`: ユーザー提供のコールバックおよびペイロード。

`git push [<remoteurl>|<repo>] [<refspecs>]`に相当します。
