```julia
fetch(rmt::GitRemote, refspecs; options::FetchOptions=FetchOptions(), msg="")
```

指定された `rmt` リモート git リポジトリから取得し、`refspecs` を使用して取得するリモートブランチを決定します。キーワード引数は次のとおりです。

  * `options`: 取得のオプションを決定します。たとえば、その後にプルーニングを行うかどうかです。詳細については [`FetchOptions`](@ref) を参照してください。
  * `msg`: リフログに挿入するメッセージです。
