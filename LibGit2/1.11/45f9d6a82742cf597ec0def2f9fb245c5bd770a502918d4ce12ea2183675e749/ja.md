```
push(rmt::GitRemote, refspecs; force::Bool=false, options::PushOptions=PushOptions())
```

指定された `rmt` リモート git リポジトリにプッシュし、`refspecs` を使用してプッシュするリモートブランチを決定します。キーワード引数は次のとおりです。

  * `force`: `true` の場合、競合を無視して強制プッシュが行われます。
  * `options`: プッシュのオプションを決定します。たとえば、どのプロキシヘッダーを使用するかなどです。詳細については [`PushOptions`](@ref) を参照してください。

!!! note
    プッシュの refspecs に関する情報を追加する方法は他にも2つあります。リポジトリの `GitConfig` でオプションを設定する（キーとして `push.default` を使用）か、[`add_push!`](@ref) を呼び出すことです。それ以外の場合、プッシュに効果を持たせるためには、`push` の呼び出しで明示的にプッシュ refspec を指定する必要があります。例えば、次のようにします: `LibGit2.push(repo, refspecs=["refs/heads/master"])`。

