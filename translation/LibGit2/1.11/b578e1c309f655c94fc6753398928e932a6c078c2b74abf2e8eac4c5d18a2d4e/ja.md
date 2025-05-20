```
fetch(rmt::GitRemote, refspecs; options::FetchOptions=FetchOptions(), msg="")
```

指定された `rmt` リモート git リポジトリからフェッチし、`refspecs` を使用してフェッチするリモートブランチを決定します。キーワード引数は次のとおりです。

  * `options`: フェッチのオプションを決定します。たとえば、その後にプルーニングを行うかどうかです。詳細については [`FetchOptions`](@ref) を参照してください。
  * `msg`: reflogs に挿入するメッセージです。
