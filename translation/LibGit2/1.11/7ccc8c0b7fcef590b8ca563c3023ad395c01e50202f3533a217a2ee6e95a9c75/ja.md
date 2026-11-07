```julia
fetch(rmt::GitRemote, refspecs; options::FetchOptions=FetchOptions(), msg="")
```

指定された`rmt`リモートGitリポジトリからフェッチします。フェッチするリモートブランチは、`refspecs`を使って指定します。キーワード引数は次のとおりです。

  * `options`: フェッチのオプションを指定します。たとえば、フェッチ後にプルーニングするかどうかを指定できます。詳しくは[`FetchOptions`](@ref)を参照してください。
  * `msg`: reflogに記録するメッセージです。
