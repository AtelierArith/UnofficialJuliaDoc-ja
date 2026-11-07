```julia
fetch(rmt::GitRemote, refspecs; options::FetchOptions=FetchOptions(), msg="")
```

指定されたリモート Git リポジトリ `rmt` からフェッチします。フェッチするリモートブランチは `refspecs` によって決まります。キーワード引数は次のとおりです。

  * `options`: フェッチ時のオプションを指定します。たとえば、フェッチ後にプルーニングするかどうかなどです。詳しくは [`FetchOptions`](@ref) を参照してください。
  * `msg`: reflog に記録するメッセージです。
