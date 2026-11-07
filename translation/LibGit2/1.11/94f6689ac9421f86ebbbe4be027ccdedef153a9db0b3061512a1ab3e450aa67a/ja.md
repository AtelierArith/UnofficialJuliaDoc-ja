```julia
fetch(repo::GitRepo; kwargs...)
```

リポジトリ `repo` の上流から更新を取得します。

キーワード引数は次のとおりです。

  * `remote::AbstractString="origin"`: 取得元となる `repo` のリモート名です。空の場合は、URL を使って匿名リモートを作成します。
  * `remoteurl::AbstractString=""`: `remote` の URL です。指定しない場合は、指定された `remote` の名前に基づいて決定されます。
  * `refspecs=AbstractString[]`: フェッチの設定を指定します。
  * `depth::Integer=0`: 各リモートブランチの先端から、指定した数のコミットまでにフェッチを制限します。`0` は完全なフェッチ（デフォルト）を指定します。浅いクローンから不足しているデータをすべて取得するには、`Consts.FETCH_DEPTH_UNSHALLOW` を使用します。注: 執筆時点では、depth はネットワークプロトコル（http、https、git、ssh）でのみサポートされており、ローカルファイルシステムのパスではサポートされていません。 (https://github.com/libgit2/libgit2/issues/6634)
  * `credentials=nothing`: プライベートな `remote` に対する認証時に、認証情報や設定を指定します。
  * `callbacks=Callbacks()`: ユーザーが指定するコールバックとペイロードです。

`git fetch [--depth <depth>] [<remoteurl>|<repo>] [<refspecs>]` と同等です。
