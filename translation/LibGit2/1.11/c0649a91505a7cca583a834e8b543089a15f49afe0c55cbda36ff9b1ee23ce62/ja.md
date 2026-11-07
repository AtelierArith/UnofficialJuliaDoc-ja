```julia
push(rmt::GitRemote, refspecs; force::Bool=false, options::PushOptions=PushOptions())
```

指定した `rmt` リモート Git リポジトリにプッシュします。プッシュ先のリモートブランチは `refspecs` に基づいて決定されます。キーワード引数は次のとおりです。

  * `force`: `true` の場合、競合を無視して強制プッシュします。
  * `options`: プッシュ時のオプションを指定します。たとえば、使用するプロキシヘッダーなどです。詳しくは [`PushOptions`](@ref) を参照してください。

!!! note
    プッシュの refspec に関する情報は、ほかに 2 つの方法で追加できます。リポジトリの `GitConfig` にオプションを設定する方法（キーは `push.default`）と、[`add_push!`](@ref) を呼び出す方法です。どちらも行わない場合、効果を得るには `push` の呼び出しでプッシュ refspec を明示的に指定する必要があります。たとえば、次のように指定します。`LibGit2.push(repo, refspecs=["refs/heads/master"])`。

